class CreateSubforums < ActiveRecord::Migration[5.1]
  def change
    create_table :subforums do |t|
      t.belongs_to :forum
      t.integer :subforum_show_order, :default => 1
      t.string :subforum_name
      t.string :subforum_icon
      t.string :subforum_name_translit, index: true

    #  t.timestamps
    end
  end
end
