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
  end

  def edit; end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      handle_successful_create
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @link.update(link_params)
      redirect_to links_path, notice: t('links.notices.updated')
    else
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
    links = current_user.links
    links = links.where('tags LIKE ?', "%#{params[:tag]}%") if params[:tag].present?
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
end
