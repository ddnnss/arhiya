class CreateForums < ActiveRecord::Migration[5.1]
  def change
    create_table :forums do |t|
      t.string :forum_name
      t.string :forum_name_translit
      t.string :forum_icon

     # t.timestamps
    end
  end
end
