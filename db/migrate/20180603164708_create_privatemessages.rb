class CreatePrivatemessages < ActiveRecord::Migration[5.1]
  def change
    create_table :privatemessages do |t|
      t.belongs_to  :player
      t.text        :message_text
      t.integer     :message_for_id
      t.boolean     :message_read, :default => false
      t.timestamps
    end
  end
end
