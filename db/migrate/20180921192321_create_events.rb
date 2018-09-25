class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :event_number
      t.string :event_creator
      t.string :event_name
      t.string :event_squads, :default => ''
      t.string :event_players, :default => ''
      t.time   :event_time
      t.date :event_date
      t.string :event_link, :default => ''
      t.text :event_info, :default => ''

      t.boolean :event_group, :default => false
      t.boolean :event_active, :default => true



    end
  end
end
