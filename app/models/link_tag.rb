# frozen_string_literal: true

# Join model connecting links and tags
class LinkTag < ApplicationRecord
  belongs_to :link
  belongs_to :tag
end
