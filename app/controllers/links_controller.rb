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
end
