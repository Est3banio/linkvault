# frozen_string_literal: true

# Base controller for the LinkVault application
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  allow_browser versions: :modern
end
