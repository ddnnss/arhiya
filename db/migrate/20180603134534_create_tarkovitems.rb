class CreateTarkovitems < ActiveRecord::Migration[5.1]
  def change
    create_table :tarkovitems do |t|
      t.belongs_to :player
      t.string  :item_name
      t.string  :item_name_caps, index: true
      t.string  :item_name_translit
      t.string  :item_type, :default => '', index: true
      t.string  :item_icon, :default => ''
      t.string  :item_image, :default => 'noimage.jpj'
      t.string  :item_tags, :default => '', index: true
      t.text    :item_info, :default => ''
      t.integer :item_to_sell_count, :default => 0
      t.integer :item_price_virt_rub, index: true
      t.integer :item_price_real_rub, :default => 0
      t.integer :item_price_virt_usd, :default => 0
      t.integer :item_price_virt_eur, :default => 0
      t.integer :item_barter_for, :default => 0
      t.boolean :item_barter, :default => false, index: true

      t.timestamps
    end
  end
end
