class CreateSubforums < ActiveRecord::Migration[5.1]
  def change
    create_table :subforums do |t|
      t.belongs_to :forum
      t.integer :subforum_show_order, :default => 1
      t.string :subforum_name
      t.string :subforum_icon
      t.string :subforum_name_translit, index: true
      t.string  :subforum_temp1
      t.string  :subforum_temp2
      t.string  :subforum_temp3
      t.string  :subforum_temp4


    #  t.timestamps
    end
  end
end
