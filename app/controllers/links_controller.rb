class LinksController < ApplicationController
  before_action :set_link, only: [ :show, :edit, :update, :destroy ]

def index
  @links = Link.all
end

  def show; end

  def new
    @link = Link.new
  end

def create
  @link = Link.new(link_params)
  if @link.save
    respond_to do |format|
      format.html { redirect_to links_path, notice: "Link successfully added." }
      format.turbo_stream { render turbo_stream: turbo_stream.prepend("links", partial: "links/link", locals: { link: @link }) }
    end
  else
    render :new, status: :unprocessable_entity
  end
end

  def edit; end

def update
    if @link.update(link_params)
      redirect_to links_path, notice: "Link updated."
    else
      render :edit, status: :unprocessable_entity
    end
end

def destroy
  @link.destroy
  respond_to do |format|
    format.html { redirect_to links_path, notice: "Link deleted." }
    format.turbo_stream { render turbo_stream: turbo_stream.remove("link_#{@link.id}") }
  end
end

  private

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:title, :url, :description, :read)
  end
end
