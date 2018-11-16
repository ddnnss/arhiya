class CreatePlayerstats < ActiveRecord::Migration[5.1]
  def change
    create_table :playerstats do |t|
      t.string :player_nickname, :default => 'Unknown'
      t.string :player_id, :default => '0'
      t.integer :player_kills, :default => 0
      t.integer :player_deaths, :default => 0
      t.timestamps
    end
  end
end
