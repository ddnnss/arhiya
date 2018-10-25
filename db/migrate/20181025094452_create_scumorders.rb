class CreateScumorders < ActiveRecord::Migration[5.1]
  def change
    create_table :scumorders do |t|
      t.belongs_to :player
      t.text :order_items
      t.integer :order_total_price
      t.integer :order_discount, :default => 0


      t.boolean :order_complete, :default => false

      t.timestamps
    end
  end
end
