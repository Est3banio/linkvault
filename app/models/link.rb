# frozen_string_literal: true

require 'metainspector'

# Model representing a saved link with metadata
class Link < ApplicationRecord
  belongs_to :user
  has_many :link_tags, dependent: :destroy
  has_many :tags, through: :link_tags
  before_save :fetch_meta_data, if: -> { url_changed? }

  def tags=(value)
    return unless value.is_a?(String)
    
    tag_names = value.split(',').map(&:strip).reject(&:blank?)
    @pending_tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
  end

  after_save :assign_tags

  private

  def assign_tags
    return unless @pending_tags

    self.tags.clear
    self.tags << @pending_tags
    @pending_tags = nil
  end

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
