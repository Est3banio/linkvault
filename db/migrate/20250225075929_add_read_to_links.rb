# frozen_string_literal: true

# Migration to add read status to links
class AddReadToLinks < ActiveRecord::Migration[8.0]
  def change
    add_column :links, :read, :boolean, default: false
  end
end
