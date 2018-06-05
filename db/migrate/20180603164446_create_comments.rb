class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.belongs_to  :player
      t.string      :comment_rate
      t.text        :comment_text

      t.integer     :comment_for_id




      t.timestamps
    end
  end
end
