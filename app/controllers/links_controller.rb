class LinksController < ApplicationController
  before_action :set_link, only: [ :show, :edit, :update, :destroy ]

  def index
  @links = Link.all.order("created_at: :desc")
  end

  def show; end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)
    if @link.save
      redirect_to links_path, notice: "Link was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def dstroy
    @link.destroy
    redirect_to links_path, notice: "Link deleted."
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:title, :url, :description, :read)
  end
end
