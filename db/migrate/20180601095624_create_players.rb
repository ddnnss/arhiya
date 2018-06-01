class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :player_email
      t.string :player_avatar

    #  t.timestamps
    end
  end
end
