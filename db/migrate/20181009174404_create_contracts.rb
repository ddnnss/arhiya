class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts do |t|
      t.belongs_to :squad
      t.string :contract_name
      t.string :contract_image
      t.string :contract_duration
      t.string :contract_reward
      t.text   :contract_info, :default => ''

    end
  end
end
