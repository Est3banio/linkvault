# frozen_string_literal: true

class AddReadToLinks < ActiveRecord::Migration[8.0]
  def change
    add_column :links, :read, :boolean, default: false
  end
end
