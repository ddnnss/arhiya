class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.belongs_to :squad
      t.string  :player_email, index: true
      t.string  :player_id, index: true
      t.string  :player_nickname
      t.string  :player_nickname_color, :default => '#FFFFFF'
      t.string  :player_nickname_translit, index: true
      t.string  :player_password
      t.string  :player_avatar, :default => 'noavatar.png'
      t.string  :player_rank , :default => 'Новичек'
      t.string  :player_vk_link, :default => ''
      t.string  :player_discord_link, :default => ''
      t.string  :player_money_history, :default => ''
      t.string  :player_squad_request, :default => ''
      t.string  :player_last_v, :default => ''
      t.string  :player_last_zp, :default => ''
      t.string  :player_rating, :default => ''

      t.text    :player_shop_history
      t.text    :player_cart
      
      t.date    :player_lastlogin


      t.integer :player_wallet , :default => 0

    
      t.text    :player_info , :default => ''
      t.text    :player_admin_info , :default => ''

      t.boolean :squad_leader , :default => false
      t.boolean :player_first_edit, :default => false
      t.boolean :player_activated, :default => false
      t.boolean :player_admin, :default => false
      t.boolean :player_banned, :default => false
      t.boolean :player_welcome_bonus, :default => false
      t.string  :player_temp1
      t.string  :player_temp2
      t.string  :player_temp3
      t.string  :player_temp4
      t.timestamps
    end
  end
end
