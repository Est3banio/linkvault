# frozen_string_literal: true

module AdminAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :ensure_admin
  end

  private

  def ensure_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
end