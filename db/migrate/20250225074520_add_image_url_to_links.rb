# frozen_string_literal: true

# Migration to add image_url column to links
class AddImageUrlToLinks < ActiveRecord::Migration[8.0]
  def change
    add_column :links, :image_url, :string
  end
end
