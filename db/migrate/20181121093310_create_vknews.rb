class CreateVknews < ActiveRecord::Migration[5.1]
  def change
    create_table :vknews do |t|
      t.string :news_id
      t.string :news_text
      t.string :news_name
      t.string :news_image
      t.string :news_link
      t.timestamps
    end
  end
end
