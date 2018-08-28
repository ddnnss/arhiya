class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.belongs_to  :event
      t.belongs_to  :player
      t.string      :comment_rate
      t.text        :comment_text
      t.string  :comment_temp1
      t.string  :comment_temp2

      t.timestamps
    end
  end
end
