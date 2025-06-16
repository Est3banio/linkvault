# frozen_string_literal: true

# Controller for managing user links
class LinksController < ApplicationController
  before_action :set_link, only: %i[show edit update destroy]

  def index
    @links = filtered_links

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show; end

  def new
    @link = Link.new
    @available_tags = current_user.links.joins(:tags).group('tags.name').pluck('tags.name').sort

    # Handle Web Share Target API parameters
    return if params[:url].blank?

    handle_shared_url
  end

  def edit
    @available_tags = current_user.links.joins(:tags).group('tags.name').pluck('tags.name').sort
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      handle_successful_create
    else
      @available_tags = current_user.links.joins(:tags).group('tags.name').pluck('tags.name').sort
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @link.update(link_params)
      notice_message = if link_params[:read].present? && @link.read_previously_changed?
                         @link.read ? t('links.notices.marked_as_read') : t('links.notices.marked_as_unread')
                       else
                         t('links.notices.updated')
                       end

      respond_to do |format|
        format.html { redirect_to links_path, notice: notice_message }
        format.turbo_stream do
          flash.now[:notice] = notice_message
          render turbo_stream: [
            turbo_stream.replace("link_#{@link.id}", partial: 'links/link', locals: { link: @link }),
            turbo_stream.replace('flash', partial: 'layouts/flash')
          ]
        end
      end
    else
      @available_tags = current_user.links.joins(:tags).group('tags.name').pluck('tags.name').sort
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_path, notice: t('links.notices.deleted') }
      format.turbo_stream { render turbo_stream: turbo_stream.remove("link_#{@link.id}") }
    end
  end

  def import
    @import_preview = nil
  end

  def import_preview
    if params[:file].blank?
      redirect_to import_links_path, alert: 'Please select a file to import.'
      return
    end

    file = params[:file]

    # Validate file type
    unless file.content_type.in?(['text/csv', 'text/html', 'application/csv']) ||
           file.original_filename.match?(/\.(csv|html)$/i)
      redirect_to import_links_path, alert: 'Please upload a CSV or HTML file.'
      return
    end

    begin
      file_content = file.read.force_encoding('UTF-8')

      if file.original_filename.match?(/\.csv$/i) || file.content_type == 'text/csv'
        @import_preview = parse_csv_content(file_content)
      elsif file.original_filename.match?(/\.html$/i) || file.content_type == 'text/html'
        @import_preview = parse_html_content(file_content)
      end

      flash.now[:alert] = "Found #{@import_preview[:errors].size} parsing errors. Please review below." if @import_preview[:errors].any?

      flash.now[:notice] = "Preview shows #{@import_preview[:links].size} links ready to import."
    rescue StandardError => e
      Rails.logger.error "Import preview error: #{e.message}"
      redirect_to import_links_path, alert: 'Error processing file. Please check the format and try again.'
    end
  end

  def import_confirm
    link_data = params[:links] || []

    imported_count = 0
    duplicate_count = 0
    error_count = 0

    link_data.each do |link_params|
      next unless link_params[:selected] == '1'

      # Check for duplicates
      existing_link = current_user.links.find_by(url: link_params[:url])
      if existing_link
        duplicate_count += 1
        next
      end

      begin
        current_user.links.create!(
          title: link_params[:title],
          url: link_params[:url],
          description: link_params[:description],
          tags: link_params[:tags]
        )
        imported_count += 1
      rescue StandardError => e
        Rails.logger.error "Import error for link #{link_params[:title]}: #{e.message}"
        error_count += 1
      end
    end

    notice_parts = []
    notice_parts << "#{imported_count} links imported successfully" if imported_count.positive?
    notice_parts << "#{duplicate_count} duplicates skipped" if duplicate_count.positive?
    notice_parts << "#{error_count} errors occurred" if error_count.positive?

    redirect_to links_path, notice: notice_parts.join(', ')
  end

  def export; end

  def export_download
    format = params[:format]
    include_read = params[:include_read] == '1'
    include_unread = params[:include_unread] == '1'
    tag_filter = params[:tag_filter].presence

    # Validate that at least one status is selected
    unless include_read || include_unread
      redirect_to export_links_path, alert: 'Please select at least one option (read or unread links).'
      return
    end

    # Build the query
    links = current_user.links.includes(:tags)

    # Filter by read status
    if include_read && include_unread
      # Include both - no additional filter needed
    elsif include_read
      links = links.where(read: true)
    elsif include_unread
      links = links.where(read: false)
    end

    # Filter by tag if specified
    links = links.joins(:tags).where(tags: { name: tag_filter }) if tag_filter.present?

    # Check if there are any links to export
    if links.empty?
      redirect_to export_links_path, alert: 'No links found matching your export criteria.'
      return
    end

    # Generate export based on format
    case format
    when 'csv'
      export_csv(links)
    when 'json'
      export_json(links)
    when 'html'
      export_html(links)
    else
      redirect_to export_links_path, alert: 'Please select an export format.'
    end
  end

  private

  def set_link
    @link = current_user.links.find(params[:id])
  end

  def link_params
    params.expect(link: %i[title url description read tags])
  end

  def filtered_links
    links = current_user.links.includes(:tags)
    links = links.joins(:tags).where(tags: { name: params[:tag] }) if params[:tag].present?
    links = links.where(read: params[:status] == 'read') if params[:status].present?
    links
  end

  def handle_successful_create
    respond_to do |format|
      format.html { redirect_to links_path, notice: t('links.notices.created') }
      format.turbo_stream do
        flash.now[:notice] = t('links.notices.created')
        render turbo_stream: [
          turbo_stream.prepend('links', partial: 'links/link', locals: { link: @link }),
          turbo_stream.replace('flash', partial: 'layouts/flash')
        ]
      end
    end
  end

  def handle_shared_url
    shared_url = params[:url]

    # Basic URL validation and normalization
    shared_url = "https://#{shared_url}" if !shared_url.match?(%r{\Ahttps?://}) && !shared_url.start_with?('//')

    begin
      # Extract metadata from the shared URL
      metadata_service = LinkMetadataService.new(shared_url)
      metadata = metadata_service.extract_metadata

      if metadata[:error]
        # Fallback to basic URL and title from share parameters
        @link.url = shared_url
        @link.title = params[:title].presence || metadata[:title] || 'Shared Link'
        @link.description = params[:text].presence
        flash.now[:notice] = "Shared link added! We couldn't fetch full metadata, but you can edit the details below."
      else
        # Use extracted metadata
        @link.url = metadata[:url]
        @link.title = metadata[:title]
        @link.description = metadata[:description] || params[:text].presence
        @link.image_url = metadata[:image_url]
        flash.now[:notice] = 'Link details loaded from the shared page! Review and save below.'
      end
    rescue StandardError => e
      Rails.logger.error "Error processing shared URL #{shared_url}: #{e.message}"

      # Fallback to basic parameters
      @link.url = shared_url
      @link.title = params[:title].presence || 'Shared Link'
      @link.description = params[:text].presence
      flash.now[:alert] = 'Added shared link with basic details. You can edit them below.'
    end
  end

  def parse_csv_content(content)
    require 'csv'

    links = []
    errors = []

    begin
      row_number = 0
      CSV.parse(content, headers: true, skip_empty_rows: true) do |row|
        row_number += 1

        # Support flexible column names
        title = row['title'] || row['Title'] || row['name'] || row['Name']
        url = row['url'] || row['URL'] || row['link'] || row['Link']
        tags = row['tags'] || row['Tags'] || row['tag'] || row['Tag'] || ''
        description = row['description'] || row['Description'] || row['notes'] || row['Notes'] || ''

        if url.blank?
          errors << "Row #{row_number + 1}: Missing URL"
          next
        end

        # Basic URL validation and normalization
        url = normalize_url(url)

        links << {
          title: title.presence || extract_title_from_url(url),
          url: url,
          tags: tags,
          description: description
        }
      end
    rescue CSV::MalformedCSVError => e
      errors << "CSV parsing error: #{e.message}"
    end

    { links: links, errors: errors }
  end

  def parse_html_content(content)
    require 'nokogiri'

    links = []
    errors = []

    begin
      doc = Nokogiri::HTML(content)

      # Parse standard bookmark format (Netscape/Chrome/Firefox export)
      doc.css('a').each do |link_node|
        href = link_node['href']
        next if href.blank?

        title = link_node.text.strip
        tags = ''
        description = ''

        # Look for tags in various possible attributes
        if link_node.parent && link_node.parent.name == 'dt'
          # Check for folder structure (tags)
          folder_elements = []
          current = link_node.parent
          while current
            folder_elements << current.previous_element.text.strip if current.name == 'dl' && current.previous_element&.name == 'h3'
            current = current.parent
          end
          tags = folder_elements.reverse.join(', ') if folder_elements.any?
        end

        # Look for description in next DD element
        description = link_node.parent.next_element.text.strip if link_node.parent&.next_element&.name == 'dd'

        url = normalize_url(href)

        links << {
          title: title.presence || extract_title_from_url(url),
          url: url,
          tags: tags,
          description: description
        }
      end
    rescue Nokogiri::XML::SyntaxError => e
      errors << "HTML parsing error: #{e.message}"
    end

    { links: links, errors: errors }
  end

  def normalize_url(url)
    return url if url.match?(%r{\Ahttps?://})

    # Add protocol if missing
    url.start_with?('//') ? "https:#{url}" : "https://#{url}"
  end

  def extract_title_from_url(url)
    URI.parse(url).host&.gsub(/^www\./, '') || url
  rescue URI::InvalidURIError
    url
  end

  def export_csv(links)
    require 'csv'

    filename = "linkvault_export_#{Date.current.strftime('%Y-%m-%d')}.csv"

    csv_data = CSV.generate(headers: true) do |csv|
      csv << %w[title url tags created_at read description]

      links.find_each do |link|
        csv << [
          link.title,
          link.url,
          link.tags_as_string,
          link.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          link.read? ? 'true' : 'false',
          link.description
        ]
      end
    end

    send_data csv_data, filename: filename, type: 'text/csv'
  end

  def export_json(links)
    filename = "linkvault_export_#{Date.current.strftime('%Y-%m-%d')}.json"

    json_data = {
      exported_at: Time.current.iso8601,
      total_links: links.count,
      links: links.map do |link|
        {
          id: link.id,
          title: link.title,
          url: link.url,
          description: link.description,
          image_url: link.image_url,
          tags: link.tags_as_string.split(', ').compact_blank,
          read: link.read?,
          created_at: link.created_at.iso8601,
          updated_at: link.updated_at.iso8601
        }
      end
    }

    send_data json_data.to_json, filename: filename, type: 'application/json'
  end

  def export_html(links)
    filename = "linkvault_export_#{Date.current.strftime('%Y-%m-%d')}.html"

    # Group links by tags for folder structure
    tagged_links = {}
    untagged_links = []

    links.find_each do |link|
      link_tags = link.tags_as_string.split(', ').compact_blank

      if link_tags.any?
        link_tags.each do |tag|
          tagged_links[tag] ||= []
          tagged_links[tag] << link
        end
      else
        untagged_links << link
      end
    end

    html_content = <<~HTML
      <!DOCTYPE NETSCAPE-Bookmark-file-1>
      <!-- This is an automatically generated file.
           It will be read and overwritten.
           DO NOT EDIT! -->
      <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
      <TITLE>LinkVault Bookmarks</TITLE>
      <H1>LinkVault Bookmarks</H1>
      <DL><p>
    HTML

    # Add tagged links in folders
    tagged_links.each do |tag, tag_links|
      html_content += "    <DT><H3>#{CGI.escapeHTML(tag)}</H3>\n"
      html_content += "    <DL><p>\n"
      tag_links.each do |link|
        add_time = link.created_at.to_i
        html_content += "        <DT><A HREF=\"#{CGI.escapeHTML(link.url)}\" ADD_DATE=\"#{add_time}\">" \
                        "#{CGI.escapeHTML(link.title)}</A>\n"
        html_content += "        <DD>#{CGI.escapeHTML(link.description)}\n" if link.description.present?
      end
      html_content += "    </DL><p>\n"
    end

    # Add untagged links
    if untagged_links.any?
      html_content += "    <DT><H3>Uncategorized</H3>\n"
      html_content += "    <DL><p>\n"
      untagged_links.each do |link|
        add_time = link.created_at.to_i
        html_content += "        <DT><A HREF=\"#{CGI.escapeHTML(link.url)}\" ADD_DATE=\"#{add_time}\">#{CGI.escapeHTML(link.title)}</A>\n"
        html_content += "        <DD>#{CGI.escapeHTML(link.description)}\n" if link.description.present?
      end
      html_content += "    </DL><p>\n"
    end

    html_content += "</DL><p>\n"

    send_data html_content, filename: filename, type: 'text/html'
  end
end
