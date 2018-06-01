class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.belongs_to :topic
      t.belongs_to :player
      t.string :post_text
      t.string :post_name_caps
      t.string :post_name_translit

    #  t.timestamps
    end
  end
end
