class AddImageUrlToLinks < ActiveRecord::Migration[8.0]
  def change
    add_column :links, :image_url, :string
  end
end
