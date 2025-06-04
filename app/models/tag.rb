# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :link_tags, dependent: :destroy
  has_many :links, through: :link_tags
end
