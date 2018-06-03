class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.belongs_to :topic
      t.belongs_to :player
      t.text :post_text


     t.timestamps
    end
  end
end
