# frozen_string_literal: true

# Migration to add tags column to links
class AddTagsToLinks < ActiveRecord::Migration[8.0]
  def change
    add_column :links, :tags, :string
  end
end
