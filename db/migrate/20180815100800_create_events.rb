class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :event_name
      t.string :event_name_translit, index: true
      t.string :event_type, index: true
      t.string :event_day
      t.string :event_time

      t.string :event_tamriel_adventure_players, :default => ''
      t.string :event_guild_players, :default => ''

      t.string :event_pvp_sirodil_tank_players, :default => ''
      t.string :event_pvp_sirodil_heal_players, :default => ''
      t.string :event_pvp_sirodil_dd_players, :default => ''

      t.string :event_pvp_bg_main_player1, :default => ''
      t.string :event_pvp_bg_main_player2, :default => ''
      t.string :event_pvp_bg_main_player3, :default => ''
      t.string :event_pvp_bg_main_player4, :default => ''
      t.string :event_pvp_bg_add_player1, :default => ''
      t.string :event_pvp_bg_add_player2, :default => ''
      t.string :event_pvp_bg_add_player3, :default => ''
      t.string :event_pvp_bg_add_player4, :default => ''

      t.string :event_pve_main_player1, :default => ''
      t.string :event_pve_main_player2, :default => ''
      t.string :event_pve_main_player3, :default => ''
      t.string :event_pve_main_player4, :default => ''
      t.string :event_pve_add_player1, :default => ''
      t.string :event_pve_add_player2, :default => ''
      t.string :event_pve_add_player3, :default => ''
      t.string :event_pve_add_player4, :default => ''

      t.string :event_trial_main_player1, :default => ''
      t.string :event_trial_main_player2, :default => ''
      t.string :event_trial_main_player3, :default => ''
      t.string :event_trial_main_player4, :default => ''
      t.string :event_trial_main_player5, :default => ''
      t.string :event_trial_main_player6, :default => ''
      t.string :event_trial_main_player7, :default => ''
      t.string :event_trial_main_player8, :default => ''
      t.string :event_trial_main_player9, :default => ''
      t.string :event_trial_main_player10, :default => ''
      t.string :event_trial_main_player11, :default => ''
      t.string :event_trial_main_player12, :default => ''

      t.string :event_trial_add_player1, :default => ''
      t.string :event_trial_add_player2, :default => ''
      t.string :event_trial_add_player3, :default => ''
      t.string :event_trial_add_player4, :default => ''
      t.string :event_trial_add_player5, :default => ''
      t.string :event_trial_add_player6, :default => ''
      t.string :event_trial_add_player7, :default => ''
      t.string :event_trial_add_player8, :default => ''
      t.string :event_trial_add_player9, :default => ''
      t.string :event_trial_add_player10, :default => ''
      t.string :event_trial_add_player11, :default => ''
      t.string :event_trial_add_player12, :default => ''

      t.string :event_link, :default => ''
      t.text   :event_info, :default => ''

      t.integer :event_creator
      t.integer :event_votes_count, :default => 0
      t.integer :event_votes_summ, :default => 0

      t.boolean :event_end, :default => false

      t.timestamps
    end
  end
end
