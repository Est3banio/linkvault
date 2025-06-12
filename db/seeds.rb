# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create admin user
admin_user = User.find_or_create_by!(email: 'admin@linkvault.local') do |user|
  user.password = 'admin123456'
  user.password_confirmation = 'admin123456'
  user.admin = true
end

Rails.logger.debug { "Admin user created: #{admin_user.email} (admin: #{admin_user.admin?})" }

# Create regular user
regular_user = User.find_or_create_by!(email: 'user@linkvault.local') do |user|
  user.password = 'user123456'
  user.password_confirmation = 'user123456'
  user.admin = false
end

Rails.logger.debug { "Regular user created: #{regular_user.email} (admin: #{regular_user.admin?})" }
