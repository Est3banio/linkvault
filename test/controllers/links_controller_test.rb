# frozen_string_literal: true

require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test 'should get new' do
    get new_link_url

    assert_response :success
  end

  test 'should handle shared URL parameters' do
    get new_link_url, params: { url: 'https://example.com', title: 'Example Site', text: 'Test description' }

    assert_response :success

    # Check that the flash message appears (indicating shared URL was processed)
    assert flash[:notice].present? || flash[:alert].present?
  end

  test 'should handle invalid shared URL gracefully' do
    get new_link_url, params: { url: 'not-a-url' }

    assert_response :success

    # Should still render the form even with invalid URL
    assert_select 'form'
  end

  test 'should show different header for shared links' do
    get new_link_url, params: { url: 'https://example.com' }

    assert_response :success

    # Check for shared link specific content
    assert_select 'h1', text: 'Save Shared Link'
  end
end
