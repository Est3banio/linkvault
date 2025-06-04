# frozen_string_literal: true

require 'metainspector'

# Model representing a saved link with metadata
class Link < ApplicationRecord
  belongs_to :user
  before_save :fetch_meta_data, if: -> { url_changed? }

  private

  def fetch_meta_data
    page = MetaInspector.new(url)
    update_meta_attributes(page)
  rescue StandardError => e
    Rails.logger.error "MetaInspector Error: #{e.message}"
  end

  def update_meta_attributes(page)
    self.title = page.title.presence || title
    self.description = page.description.presence || description
    self.image_url = page.images.best
  end
end
