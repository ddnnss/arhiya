class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :number
      t.string :name
      t.string :time
      t.string :date
      t.string :link, :default => ''
      t.text :info, :default => ''
      t.text :players, :default => ''



    end
  end
end
