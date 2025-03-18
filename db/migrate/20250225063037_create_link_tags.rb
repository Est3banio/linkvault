# frozen_string_literal: true

class CreateLinkTags < ActiveRecord::Migration[8.0]
  def change
    create_table :link_tags do |t|
      t.references :link, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
