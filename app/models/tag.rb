# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :link_tags, dependent: :destroy
  has_many :links, through: :link_tags

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

  before_save :normalize_name

  private

  def normalize_name
    self.name = name.strip.downcase
  end
end
