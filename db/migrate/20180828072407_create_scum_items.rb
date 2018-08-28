class CreateScumItems < ActiveRecord::Migration[5.1]
  def change
    create_table :scum_items do |t|
      t.string  :scum_item_image
      t.string  :scum_item_price
      t.string  :scum_item_name, index: true
      t.string  :scum_item_name_translit, index: true

      t.timestamps
    end
  end
end
