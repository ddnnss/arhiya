class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.belongs_to :subforum
      t.belongs_to :player
      t.string :topic_name
      t.string :topic_name_caps
      t.string :topic_name_translit, index: true
      t.string :topic_icon
      t.string :topic_home_image
      t.string :topic_home_type
      t.string :topic_home_icon
      t.integer :topic_views , :default => 0
      t.boolean :topic_show_homepage, :default => false, index: true
      t.boolean :topic_pinned, :default => false
      t.boolean :topic_closed, :default => false
     t.timestamps
    end
  end
end
