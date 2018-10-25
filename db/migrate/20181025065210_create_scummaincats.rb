class CreateScummaincats < ActiveRecord::Migration[5.1]
  def change
    create_table :scummaincats do |t|
      t.string :cat_name
      t.string :cat_image
      t.string :cat_name_translit
      t.string :cat_info
      t.integer :cat_views, :default => 0
      t.boolean :cat_show, :default => true


      t.timestamps
    end
  end
end
