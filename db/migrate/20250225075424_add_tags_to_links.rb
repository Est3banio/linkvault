# frozen_string_literal: true

class AddTagsToLinks < ActiveRecord::Migration[8.0]
  def change
    add_column :links, :tags, :string
  end
end
