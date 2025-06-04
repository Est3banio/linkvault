# frozen_string_literal: true

require 'test_helper'

class RegistrationDisabledTest < ActionDispatch::IntegrationTest
  test "should not allow access to sign up page" do
    get "/users/sign_up"
    assert_response :not_found
  end

  test "should not allow registration POST requests" do
    post "/users", params: {
      user: {
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }
    assert_response :not_found
  end
end