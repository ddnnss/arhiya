class CreateScumitems < ActiveRecord::Migration[5.1]
  def change
    create_table :scumitems do |t|
      t.belongs_to :scummaincat
      t.string :item_name
      t.string :item_image
      t.string :item_spawn_name
      t.string :item_name_translit
      t.integer :item_buys, :default => 0
      t.integer :item_price, :default => 0
      t.integer :item_squad_discount, :default => 0
      t.boolean :item_show, :default => true

      t.timestamps
    end
  end
end
