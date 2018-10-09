class CreateEventtexts < ActiveRecord::Migration[5.1]
  def change
    create_table :eventtexts do |t|

      t.string :event_name
      t.string :event_image
      t.text :event_info, :default => ''

    end
  end
end
