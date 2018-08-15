class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string  :player_email, index: true
      t.string  :player_id, index: true
      t.string  :player_nickname
      t.string  :player_nickname_translit, index: true
      t.string  :player_password
      t.string  :player_avatar, :default => 'noavatar.png'
      t.string  :player_rank , :default => 'Гость'
      t.string  :player_skype_link, :default => 'Нет данных'
      t.string  :player_vk_link, :default => 'Нет данных'
      t.string  :player_tm_link, :default => 'Нет данных'
      t.string  :player_discord_link, :default => 'Нет данных'
      t.string  :player_system_messages, :default => ''
      t.string  :player_cp, :default => ''
      t.string  :player_pve_roles, :default => ''
      t.string  :player_pvp_roles, :default => ''
      t.string  :player_pvp_side, :default => ''
      t.string  :player_game_stats, :default => ''
      t.string  :player_prime_time, :default => ''
      t.string  :player_events, :default => '', index: true
      t.date    :player_lastlogin

      t.integer :player_votes_count , :default => 0
      t.integer :player_votes_summ , :default => 0
      t.integer :player_event_coming , :default => 0, index: true
      t.integer :player_gold , :default => 0, index: true
      t.integer :player_vauchers , :default => 0, index: true




      t.text    :player_info , :default => ''
      t.text    :player_admin_info , :default => ''

      t.boolean :player_activated, :default => false
      t.boolean :player_admin, :default => false
      t.boolean :player_banned, :default => false
      t.boolean :player_event_starter, :default => false
      t.timestamps
    end
  end
end
