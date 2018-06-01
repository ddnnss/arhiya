class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.belongs_to :subforum
      t.belongs_to :player
      t.string :topic_name
      t.string :topic_name_caps
      t.string :topic_name_translit
      t.string :topic_icon
      t.boolean :topic_show_homepage
      t.boolean :topic_pinned
   #   t.timestamps
    end
  end
end
