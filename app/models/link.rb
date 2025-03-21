require "metainspector"

class Link < ApplicationRecord
  belongs_to :user
  before_save :fetch_meta_data, if: -> { url_changed? }

  private

  def fetch_meta_data
    page = MetaInspector.new(url)
    self.title = page.title.presence || title
    self.description = page.description.presence || description
    self.image_url = page.images.best
  rescue StandardError => e
    Rails.logger.error "MetaInspector Error: #{e.message}"
  end
end
