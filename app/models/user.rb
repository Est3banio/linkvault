# frozen_string_literal: true

# User model with Devise authentication
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_many :links, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  def admin?
    admin
  end
end
