class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.belongs_to :topic
      t.belongs_to :player
      t.text :post_text
      t.string  :post_temp1
      t.string  :post_temp2
      t.string  :post_temp3
      t.string  :post_temp4
      t.boolean :post_wiki ,  :default => false

     t.timestamps
    end
  end
end
