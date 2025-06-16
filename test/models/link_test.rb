# frozen_string_literal: true

require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test 'should handle empty string tags' do
    link = @user.links.build(title: 'Test', url: 'https://example.com', tags: '')

    assert link.save
    assert_equal '', link.tags_as_string
    assert_equal 0, link.association(:tags).target.count
  end

  test 'should handle nil tags' do
    link = @user.links.build(title: 'Test', url: 'https://example.com', tags: nil)

    assert link.save
    assert_equal '', link.tags_as_string
    assert_equal 0, link.association(:tags).target.count
  end

  test 'should handle single tag as string' do
    link = @user.links.build(title: 'Test', url: 'https://example.com', tags: 'work')

    assert link.save
    assert_equal 'work', link.tags_as_string
    assert_equal 1, link.association(:tags).target.count
  end

  test 'should handle multiple tags as string' do
    link = @user.links.build(title: 'Test', url: 'https://example.com', tags: 'work, development, rails')

    assert link.save
    assert_equal 'work, development, rails', link.tags_as_string
    assert_equal 3, link.association(:tags).target.count
  end

  test 'should handle tags with extra spaces' do
    link = @user.links.build(title: 'Test', url: 'https://example.com', tags: ' work , development , rails ')

    assert link.save
    assert_equal 'work, development, rails', link.tags_as_string
    assert_equal 3, link.association(:tags).target.count
  end

  test 'should handle array of tags' do
    link = @user.links.build(title: 'Test', url: 'https://example.com', tags: %w[work development rails])

    assert link.save
    assert_equal 'work, development, rails', link.tags_as_string
    assert_equal 3, link.association(:tags).target.count
  end

  test 'should handle array with empty strings' do
    link = @user.links.build(title: 'Test', url: 'https://example.com', tags: ['work', '', 'development'])

    assert link.save
    assert_equal 'work, development', link.tags_as_string
    assert_equal 2, link.association(:tags).target.count
  end

  test 'should handle numeric input' do
    link = @user.links.build(title: 'Test', url: 'https://example.com', tags: 123)

    assert link.save
    assert_equal '123', link.tags_as_string
    assert_equal 1, link.association(:tags).target.count
  end

  test 'should not create duplicate tags' do
    # Create first link with tag
    link1 = @user.links.create!(title: 'Test 1', url: 'https://example1.com', tags: 'work')

    # Create second link with same tag
    link2 = @user.links.create!(title: 'Test 2', url: 'https://example2.com', tags: 'work')

    # Should have only one Tag record
    assert_equal 1, Tag.where(name: 'work').count

    # Both links should reference the same tag
    assert_equal 'work', link1.tags_as_string
    assert_equal 'work', link2.tags_as_string
  end

  test 'should update tags correctly' do
    link = @user.links.create!(title: 'Test', url: 'https://example.com', tags: 'old_tag')

    assert_equal 'old_tag', link.tags_as_string

    # Update tags
    link.update!(tags: 'new_tag, another_tag')

    assert_equal 'new_tag, another_tag', link.tags_as_string
    assert_equal 2, link.association(:tags).target.count
  end
end
