class CreateSquads < ActiveRecord::Migration[5.1]
  def change
    create_table :squads do |t|
      t.integer :squad_number #new
      t.string :squad_name
      t.string :squad_name_translit
      t.string :squad_avatar
      t.string :squad_rating
      t.integer :squad_leader
      t.string  :squad_in_request, :default => ''
      t.text :squad_info
      t.boolean :squad_recruting , :default => false

      t.timestamps
    end
  end
end
