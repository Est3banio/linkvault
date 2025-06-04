# frozen_string_literal: true

# Migration to create tags table
class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
