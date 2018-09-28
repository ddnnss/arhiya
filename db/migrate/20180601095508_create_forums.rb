class CreateForums < ActiveRecord::Migration[5.1]
  def change
    create_table :forums do |t|
      t.string :forum_name
      t.integer :forum_show_order, :default => 1
      t.string  :forum_temp1
      t.string  :forum_temp2
      t.string  :forum_temp3
      t.string  :forum_temp4
      t.boolean :forum_wiki ,  :default => false

     # t.timestamps
    end
  end
end
