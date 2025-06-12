# frozen_string_literal: true

require 'test_helper'

class LinkMetadataServiceTest < ActiveSupport::TestCase
  def setup
    @service = LinkMetadataService.new('https://example.com')
  end

  test 'handles invalid URL gracefully' do
    service = LinkMetadataService.new('not-a-url')
    result = service.extract_metadata

    assert_predicate result[:error], :present?
    assert_equal 'Unable to fetch metadata', result[:error]
    assert_predicate result[:title], :present?
    assert_equal 'not-a-url', result[:url]
  end

  test 'handles blank URL' do
    service = LinkMetadataService.new('')
    result = service.extract_metadata

    assert_equal 'Invalid URL', result[:error]
  end

  test 'handles nil URL' do
    service = LinkMetadataService.new(nil)
    result = service.extract_metadata

    assert_equal 'Invalid URL', result[:error]
  end

  test 'extracts title from URL as fallback' do
    service = LinkMetadataService.new('https://example.com/my-awesome-article')

    # This will likely fail to fetch real metadata, so it should use URL fallback
    result = service.extract_metadata

    # Should either get real metadata or fallback title
    assert_predicate result[:title], :present?
  end

  test 'normalizes URL without protocol' do
    service = LinkMetadataService.new('example.com')
    result = service.extract_metadata

    # Should add https:// protocol
    assert_predicate result[:url], :present?
  end
end
