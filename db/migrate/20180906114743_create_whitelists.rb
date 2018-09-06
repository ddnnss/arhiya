class CreateWhitelists < ActiveRecord::Migration[5.1]
  def change
    create_table :whitelists do |t|
      t.string :player_id
      t.string :player_nick
      t.string :player_email
      t.boolean :added, :default => false
      t.boolean :banned, :default => false

      t.timestamps
    end
  end
end
