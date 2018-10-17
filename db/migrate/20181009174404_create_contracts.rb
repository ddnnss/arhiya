class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts do |t|
      t.belongs_to :squad
      t.string :contract_name
      t.string :contract_image
      t.string :contract_duration
      t.string :contract_hh_player, :default => ''
      t.text   :contract_reward, :default => ''
      t.text   :contract_mission, :default => ''
      t.text   :contract_info, :default => ''
      t.boolean :contract_hh , :default => false

    end
  end
end
