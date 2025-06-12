# frozen_string_literal: true

require 'test_helper'

module Users
  class RegistrationsControllerTest < ActionDispatch::IntegrationTest
    def setup
      @user = users(:user)
    end

    test "user must be signed in to edit profile" do
      get edit_user_registration_path
      assert_redirected_to new_user_session_path
    end

    test "signed in user can access edit profile page" do
      sign_in @user
      get edit_user_registration_path
      assert_response :success
      assert_select 'h2', text: 'Edit Profile'
      assert_select 'form'
    end

    test "user can update email without password" do
      sign_in @user
      new_email = 'newemail@example.com'
      
      patch user_registration_path, params: {
        user: {
          email: new_email,
          current_password: ''
        }
      }
      
      assert_redirected_to edit_user_registration_path
      @user.reload
      assert_equal new_email, @user.email
      assert_equal 'Your profile has been updated successfully.', flash[:notice]
    end

    test "user can update password with current password" do
      sign_in @user
      new_password = 'newpassword123'
      
      patch user_registration_path, params: {
        user: {
          password: new_password,
          password_confirmation: new_password,
          current_password: 'password'
        }
      }
      
      assert_redirected_to edit_user_registration_path
    end

    test "user can update both email and password" do
      sign_in @user
      new_email = 'updated@example.com'
      new_password = 'newpassword123'
      
      patch user_registration_path, params: {
        user: {
          email: new_email,
          password: new_password,
          password_confirmation: new_password,
          current_password: 'password'
        }
      }
      
      assert_redirected_to edit_user_registration_path
      @user.reload
      assert_equal new_email, @user.email
    end

    test "password change requires current password" do
      sign_in @user
      new_password = 'newpassword123'
      
      patch user_registration_path, params: {
        user: {
          password: new_password,
          password_confirmation: new_password,
          current_password: ''
        }
      }
      
      assert_response :unprocessable_entity
      assert_select '#error_explanation li', text: /current password/i
    end

    test "password change requires matching confirmation" do
      sign_in @user
      
      patch user_registration_path, params: {
        user: {
          password: 'newpassword123',
          password_confirmation: 'differentpassword',
          current_password: 'password'
        }
      }
      
      assert_response :unprocessable_entity
      assert_select '#error_explanation'
    end

    test "password change requires valid current password" do
      sign_in @user
      new_password = 'newpassword123'
      
      patch user_registration_path, params: {
        user: {
          password: new_password,
          password_confirmation: new_password,
          current_password: 'wrongpassword'
        }
      }
      
      assert_response :unprocessable_entity
      assert_select '#error_explanation'
    end

    test "password must meet minimum length requirement" do
      sign_in @user
      short_password = '123'
      
      patch user_registration_path, params: {
        user: {
          password: short_password,
          password_confirmation: short_password,
          current_password: 'password'
        }
      }
      
      assert_response :unprocessable_entity
      assert_select '#error_explanation'
    end

    test "email must be valid format" do
      sign_in @user
      
      patch user_registration_path, params: {
        user: {
          email: 'invalid-email'
        }
      }
      
      assert_response :unprocessable_entity
      assert_select '#error_explanation'
    end

    test "email must be unique" do
      sign_in @user
      existing_email = users(:admin).email
      
      patch user_registration_path, params: {
        user: {
          email: existing_email
        }
      }
      
      assert_response :unprocessable_entity
      assert_select '#error_explanation'
    end

    test "user can cancel account" do
      sign_in @user
      
      assert_difference 'User.count', -1 do
        delete user_registration_path
      end
      
      assert_redirected_to root_path
    end

    test "profile form displays current user information" do
      sign_in @user
      get edit_user_registration_path
      
      assert_response :success
      assert_select "input[name='user[email]'][value='#{@user.email}']"
      assert_select "input[name='user[password]']"
      assert_select "input[name='user[password_confirmation]']"
      assert_select "input[name='user[current_password]']"
    end

    private

    def sign_in(user)
      post user_session_path, params: {
        user: {
          email: user.email,
          password: 'password'
        }
      }
    end
  end
end