# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :set_link, only: %i[show edit update destroy]

  def index
    @links = current_user.links

    # Filter nach Tags
    @links = @links.where('tags LIKE ?', "%#{params[:tag]}%") if params[:tag].present?

    # Filter nach gelesen/ungelesen
    @links = @links.where(read: params[:status] == 'read') if params[:status].present?

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show; end

  def new
    @link = Link.new
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      respond_to do |format|
        format.html { redirect_to links_path, notice: 'Link erfolgreich hinzugefügt.' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend('links', partial: 'links/link', locals: { link: @link })
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @link.update(link_params)
      redirect_to links_path, notice: 'Link updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_path, notice: 'Link deleted.' }
      format.turbo_stream { render turbo_stream: turbo_stream.remove("link_#{@link.id}") }
    end
  end

  private

  def set_link
    @link = current_user.links.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:title, :url, :description, :read, :tags)
  end
end
