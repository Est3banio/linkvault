# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :links, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :password, length: { minimum: 8 }, if: -> { password.present? }
end
