# frozen_string_literal: true

require 'metainspector'

# Model representing a saved link with metadata
class Link < ApplicationRecord
  belongs_to :user
  has_many :link_tags, dependent: :destroy
  has_many :tags, through: :link_tags
  before_save :fetch_meta_data, if: -> { url_changed? }

  def tags_as_string
    tags.map(&:name).join(', ')
  end

  def tags=(value)
    # Handle different input types gracefully
    tag_names = case value
                when String
                  value.split(',').map(&:strip).compact_blank
                when Array
                  value.map { |v| v.to_s.strip }.compact_blank
                when nil
                  []
                else
                  [value.to_s.strip].compact_blank
                end

    @pending_tag_names = tag_names
  end

  after_save :assign_tags

  private

  def assign_tags
    return unless @pending_tag_names

    begin
      # Clear existing tags
      link_tags.destroy_all

      # Create new tags and associations
      @pending_tag_names.each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        link_tags.create!(tag: tag) unless link_tags.exists?(tag: tag)
      end

      # Reload the association to reflect changes
      association(:tags).reload
    rescue StandardError => e
      # Add validation error instead of raising exception
      errors.add(:tags, "could not be processed: #{e.message}")
      Rails.logger.error "Tag assignment error for link #{id}: #{e.message}"
      raise ActiveRecord::RecordInvalid, self
    ensure
      @pending_tag_names = nil
    end
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
