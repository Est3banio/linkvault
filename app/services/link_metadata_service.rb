# frozen_string_literal: true

# Service to extract metadata from URLs using MetaInspector
class LinkMetadataService
  require 'metainspector'

  def initialize(url)
    @url = url
  end

  def extract_metadata
    return { error: 'Invalid URL' } if @url.blank?

    begin
      page = MetaInspector.new(@url, timeout: 10)

      {
        title: extract_title(page),
        description: extract_description(page),
        image_url: extract_image(page),
        url: normalize_url(page.url)
      }
    rescue MetaInspector::Error, StandardError => e
      Rails.logger.error "LinkMetadataService error for #{@url}: #{e.message}"
      {
        error: 'Unable to fetch metadata',
        title: extract_title_from_url(@url),
        url: @url
      }
    end
  end

  private

  def extract_title(page)
    page.best_title&.strip || extract_title_from_url(@url)
  end

  def extract_description(page)
    description = page.best_description&.strip
    return nil if description.blank? || description.length < 10

    # Truncate if too long
    description.length > 300 ? "#{description[0..297]}..." : description
  end

  def extract_image(page)
    # Try Open Graph image first, then other images
    image_url = page.images.best&.strip
    return nil if image_url.blank?

    # Ensure it's a valid absolute URL
    begin
      uri = URI.parse(image_url)
      uri.absolute? ? image_url : nil
    rescue URI::InvalidURIError
      nil
    end
  end

  def extract_title_from_url(url)
    # Fallback: extract title from URL

    uri = URI.parse(url)
    domain = uri.host&.gsub(/^www\./, '')
    path = uri.path&.split('/')&.last&.gsub(/[-_]/, ' ')&.titleize

    if path.present? && path != '/'
      "#{path} - #{domain}"
    else
      domain&.titleize || 'Shared Link'
    end
  rescue URI::InvalidURIError
    'Shared Link'
  end

  def normalize_url(url)
    # Ensure URL has proper protocol
    return url if url.match?(%r{\Ahttps?://})

    "https://#{url}"
  end
end
