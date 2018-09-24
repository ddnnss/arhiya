class CreateSquads < ActiveRecord::Migration[5.1]
  def change
    create_table :squads do |t|
      t.belongs_to :event
      t.string :squad_name
      t.string :squad_name_translit
      t.string :squad_avatar
      t.string :squad_rating
      t.text :squad_info
      t.boolean :squad_recruting , :default => false

      t.timestamps
    end
  end
end
