class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string  :player_email, index: true
      t.string  :player_id, index: true
      t.string  :player_nickname
      t.string  :player_nickname_translit, index: true
      t.string  :player_password
      t.string  :player_avatar, :default => 'noavatar.png'
      t.string  :player_rank , :default => 'Комрад'
      t.string  :player_vk_link, :default => ''
      t.string  :player_discord_link, :default => ''
      t.string  :player_money_history, :default => ''
      t.text    :player_shop_history
      t.text    :player_cart
      
      t.date    :player_lastlogin

      t.integer :player_wallet , :default => 0
    
      t.text    :player_info , :default => ''
      t.text    :player_admin_info , :default => ''
    

      t.boolean :player_first_edit, :default => false
      t.boolean :player_activated, :default => false
      t.boolean :player_admin, :default => false
      t.boolean :player_banned, :default => false
      t.boolean :player_welcome_bonus, :default => false
      t.timestamps
    end
  end
end
