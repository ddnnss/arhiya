class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string  :player_email, index: true
      t.string  :player_nickname
      t.string  :player_nickname_translit
      t.string  :player_password
      t.string  :player_avatar, :default => 'noavatar.png'
      t.string  :player_rank , :default => 'Новичек'
      t.string  :player_skype_link, :default => 'Нет данных'
      t.string  :player_vk_link, :default => 'Нет данных'
      t.string  :player_tm_link, :default => 'Нет данных'
      t.string  :player_discord_link, :default => 'Нет данных'
      t.string  :player_system_messages, :default => ''
      t.string  :player_already_vote , :default => ''
      t.string  :player_already_like , :default => ''

      t.date    :player_lastlogin
      t.date    :player_vip_expire

      t.integer :player_sells_count , :default => 0
      t.integer :player_buys_count , :default => 0
      t.integer :player_votes_count , :default => 0
      t.integer :player_votes_summ , :default => 0
      t.integer :player_wallet, :default => 0
      t.integer :player_loginfails, :default => 0

      t.text    :player_cart
      t.text    :player_info , :default => ''

      t.boolean :player_activated, :default => false
      t.boolean :player_welcomebonus, :default => false
      t.boolean :player_admin, :default => false
      t.boolean :player_moder, :default => false
      t.boolean :player_vip, :default => false
      t.timestamps
    end
  end
end
