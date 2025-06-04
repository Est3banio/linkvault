# frozen_string_literal: true

# Controller for the home page
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    redirect_to dashboard_path if user_signed_in?
  end

  def dashboard
    @recent_links = current_user.links.order(created_at: :desc).limit(5)
    @total_links = current_user.links.count
    @unread_links = current_user.links.where(read: false).count
    @tags = current_user.links.joins(:tags).group('tags.name').count.sort_by { |_, count| -count }.first(10)
  end
end
