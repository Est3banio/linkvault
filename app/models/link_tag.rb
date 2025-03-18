# frozen_string_literal: true

class LinkTag < ApplicationRecord
  belongs_to :link
  belongs_to :tag
end
