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
    if params[:url].present?
      handle_shared_url
    end
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
      redirect_to links_path, notice: t('links.notices.updated')
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
    unless params[:file].present?
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
      
      if @import_preview[:errors].any?
        flash.now[:alert] = "Found #{@import_preview[:errors].size} parsing errors. Please review below."
      end
      
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
        link = current_user.links.create!(
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
    notice_parts << "#{imported_count} links imported successfully" if imported_count > 0
    notice_parts << "#{duplicate_count} duplicates skipped" if duplicate_count > 0
    notice_parts << "#{error_count} errors occurred" if error_count > 0
    
    redirect_to links_path, notice: notice_parts.join(', ')
  end

  private

  def set_link
    @link = current_user.links.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:title, :url, :description, :read, :tags)
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
        render turbo_stream: turbo_stream.prepend('links', partial: 'links/link', locals: { link: @link })
      end
    end
  end

  def handle_shared_url
    shared_url = params[:url]
    
    # Basic URL validation and normalization
    unless shared_url.match?(/\Ahttps?:\/\//)
      shared_url = "https://#{shared_url}" unless shared_url.start_with?('//')
    end
    
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
        flash.now[:notice] = "Link details loaded from the shared page! Review and save below."
      end
    rescue StandardError => e
      Rails.logger.error "Error processing shared URL #{shared_url}: #{e.message}"
      
      # Fallback to basic parameters
      @link.url = shared_url
      @link.title = params[:title].presence || 'Shared Link'
      @link.description = params[:text].presence
      flash.now[:alert] = "Added shared link with basic details. You can edit them below."
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
            if current.name == 'dl' && current.previous_element&.name == 'h3'
              folder_elements << current.previous_element.text.strip
            end
            current = current.parent
          end
          tags = folder_elements.reverse.join(', ') if folder_elements.any?
        end
        
        # Look for description in next DD element
        if link_node.parent&.next_element&.name == 'dd'
          description = link_node.parent.next_element.text.strip
        end
        
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
    return url if url.match?(/\Ahttps?:\/\//)
    
    # Add protocol if missing
    url.start_with?('//') ? "https:#{url}" : "https://#{url}"
  end

  def extract_title_from_url(url)
    URI.parse(url).host&.gsub(/^www\./, '') || url
  rescue URI::InvalidURIError
    url
  end
end
