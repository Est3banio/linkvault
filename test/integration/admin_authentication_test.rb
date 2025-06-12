# frozen_string_literal: true

require 'test_helper'

class AdminAuthenticationTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:admin)
    @regular_user = users(:user)
  end

  test 'admin can access admin area' do
    sign_in @admin_user
    get admin_root_path

    assert_response :success
  end

  test 'regular user cannot access admin area' do
    sign_in @regular_user
    get admin_root_path

    assert_redirected_to root_path
    assert_equal 'Access denied. Admin privileges required.', flash[:alert]
  end

  test 'guest cannot access admin area' do
    get admin_root_path

    assert_redirected_to new_user_session_path
  end

  test 'admin navigation link appears for admin users' do
    sign_in @admin_user
    get dashboard_path

    assert_select 'a[href=?]', admin_root_path, text: 'Admin'
  end

  test 'admin navigation link does not appear for regular users' do
    sign_in @regular_user
    get dashboard_path

    assert_select 'a[href=?]', admin_root_path, false
  end
end
