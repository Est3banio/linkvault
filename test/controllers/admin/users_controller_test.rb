# frozen_string_literal: true

require 'test_helper'

module Admin
  class UsersControllerTest < ActionDispatch::IntegrationTest
    def setup
      @admin_user = users(:admin)
      @regular_user = users(:user)
    end

    test "admin can view users index" do
      sign_in @admin_user
      get admin_users_path
      assert_response :success
      assert_select 'h1', text: 'User Management'
    end

    test "admin can view user details" do
      sign_in @admin_user
      get admin_user_path(@regular_user)
      assert_response :success
      assert_select 'h1', text: 'User Details'
    end

    test "admin can create new user" do
      sign_in @admin_user
      assert_difference 'User.count', 1 do
        post admin_users_path, params: {
          user: {
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            admin: false
          }
        }
      end
      assert_redirected_to admin_user_path(User.last)
    end

    test "admin can update user" do
      sign_in @admin_user
      patch admin_user_path(@regular_user), params: {
        user: { email: 'updated@example.com' }
      }
      assert_redirected_to admin_user_path(@regular_user)
      @regular_user.reload
      assert_equal 'updated@example.com', @regular_user.email
    end

    test "admin can delete other users" do
      sign_in @admin_user
      assert_difference 'User.count', -1 do
        delete admin_user_path(@regular_user)
      end
      assert_redirected_to admin_users_path
    end

    test "admin cannot delete themselves" do
      sign_in @admin_user
      assert_no_difference 'User.count' do
        delete admin_user_path(@admin_user)
      end
      assert_redirected_to admin_users_path
    end

    test "regular user cannot access admin users controller" do
      sign_in @regular_user
      get admin_users_path
      assert_redirected_to root_path
    end
  end
end