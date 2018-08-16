# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180815100800) do

  create_table "comments", force: :cascade do |t|
    t.integer "event_id"
    t.integer "player_id"
    t.string "comment_rate"
    t.text "comment_text"
    t.integer "comment_for_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_comments_on_event_id"
    t.index ["player_id"], name: "index_comments_on_player_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "event_name"
    t.string "event_name_translit"
    t.string "event_type"
    t.string "event_day"
    t.string "event_time"
    t.string "event_tamriel_adventure_players", default: ""
    t.string "event_guild_players", default: ""
    t.string "event_pvp_sirodil_tank_players", default: ""
    t.string "event_pvp_sirodil_heal_players", default: ""
    t.string "event_pvp_sirodil_dd_players", default: ""
    t.string "event_pvp_bg_main_player1", default: ""
    t.string "event_pvp_bg_main_player2", default: ""
    t.string "event_pvp_bg_main_player3", default: ""
    t.string "event_pvp_bg_main_player4", default: ""
    t.string "event_pvp_bg_add_player1", default: ""
    t.string "event_pvp_bg_add_player2", default: ""
    t.string "event_pvp_bg_add_player3", default: ""
    t.string "event_pvp_bg_add_player4", default: ""
    t.string "event_pve_main_player1", default: ""
    t.string "event_pve_main_player2", default: ""
    t.string "event_pve_main_player3", default: ""
    t.string "event_pve_main_player4", default: ""
    t.string "event_pve_add_player1", default: ""
    t.string "event_pve_add_player2", default: ""
    t.string "event_pve_add_player3", default: ""
    t.string "event_pve_add_player4", default: ""
    t.string "event_trial_main_player1", default: ""
    t.string "event_trial_main_player2", default: ""
    t.string "event_trial_main_player3", default: ""
    t.string "event_trial_main_player4", default: ""
    t.string "event_trial_main_player5", default: ""
    t.string "event_trial_main_player6", default: ""
    t.string "event_trial_main_player7", default: ""
    t.string "event_trial_main_player8", default: ""
    t.string "event_trial_main_player9", default: ""
    t.string "event_trial_main_player10", default: ""
    t.string "event_trial_main_player11", default: ""
    t.string "event_trial_main_player12", default: ""
    t.string "event_trial_add_player1", default: ""
    t.string "event_trial_add_player2", default: ""
    t.string "event_trial_add_player3", default: ""
    t.string "event_trial_add_player4", default: ""
    t.string "event_trial_add_player5", default: ""
    t.string "event_trial_add_player6", default: ""
    t.string "event_trial_add_player7", default: ""
    t.string "event_trial_add_player8", default: ""
    t.string "event_trial_add_player9", default: ""
    t.string "event_trial_add_player10", default: ""
    t.string "event_trial_add_player11", default: ""
    t.string "event_trial_add_player12", default: ""
    t.string "event_link", default: ""
    t.text "event_info", default: ""
    t.integer "event_creator"
    t.integer "event_votes_count", default: 0
    t.integer "event_votes_summ", default: 0
    t.boolean "event_end", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_name_translit"], name: "index_events_on_event_name_translit"
    t.index ["event_type"], name: "index_events_on_event_type"
  end

  create_table "forums", force: :cascade do |t|
    t.string "forum_name"
    t.integer "forum_show_order", default: 1
  end

  create_table "players", force: :cascade do |t|
    t.string "player_email"
    t.string "player_id"
    t.string "player_nickname"
    t.string "player_nickname_translit"
    t.string "player_password"
    t.string "player_avatar", default: "noavatar.png"
    t.string "player_rank", default: "Гость"
    t.string "player_skype_link", default: "Нет данных"
    t.string "player_vk_link", default: "Нет данных"
    t.string "player_tm_link", default: "Нет данных"
    t.string "player_discord_link", default: "Нет данных"
    t.string "player_system_messages", default: ""
    t.string "player_cp", default: ""
    t.string "player_pve_roles", default: ""
    t.string "player_pve_class", default: ""
    t.string "player_pvp_roles", default: ""
    t.string "player_pvp_class", default: ""
    t.string "player_pvp_side", default: ""
    t.string "player_game_stats", default: ""
    t.string "player_prime_time", default: ""
    t.string "player_events", default: ""
    t.date "player_lastlogin"
    t.integer "player_votes_count", default: 0
    t.integer "player_votes_summ", default: 0
    t.integer "player_event_coming", default: 0
    t.integer "player_gold", default: 0
    t.integer "player_vauchers", default: 0
    t.text "player_info", default: ""
    t.text "player_admin_info", default: ""
    t.boolean "player_first_edit", default: false
    t.boolean "player_activated", default: false
    t.boolean "player_admin", default: false
    t.boolean "player_banned", default: false
    t.boolean "player_event_starter", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_email"], name: "index_players_on_player_email"
    t.index ["player_event_coming"], name: "index_players_on_player_event_coming"
    t.index ["player_events"], name: "index_players_on_player_events"
    t.index ["player_gold"], name: "index_players_on_player_gold"
    t.index ["player_id"], name: "index_players_on_player_id"
    t.index ["player_nickname_translit"], name: "index_players_on_player_nickname_translit"
    t.index ["player_vauchers"], name: "index_players_on_player_vauchers"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "topic_id"
    t.integer "player_id"
    t.text "post_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_posts_on_player_id"
    t.index ["topic_id"], name: "index_posts_on_topic_id"
  end

  create_table "privatemessages", force: :cascade do |t|
    t.integer "player_id"
    t.text "message_text"
    t.integer "message_for_id"
    t.boolean "message_read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_privatemessages_on_player_id"
  end

  create_table "subforums", force: :cascade do |t|
    t.integer "forum_id"
    t.integer "subforum_show_order", default: 1
    t.string "subforum_name"
    t.string "subforum_icon"
    t.string "subforum_name_translit"
    t.index ["forum_id"], name: "index_subforums_on_forum_id"
    t.index ["subforum_name_translit"], name: "index_subforums_on_subforum_name_translit"
  end

  create_table "topics", force: :cascade do |t|
    t.integer "subforum_id"
    t.integer "player_id"
    t.string "topic_name"
    t.string "topic_name_caps"
    t.string "topic_name_translit"
    t.string "topic_icon"
    t.string "topic_home_image"
    t.string "topic_home_type"
    t.string "topic_home_icon"
    t.integer "topic_views", default: 0
    t.boolean "topic_show_homepage", default: false
    t.boolean "topic_pinned", default: false
    t.boolean "topic_closed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_topics_on_player_id"
    t.index ["subforum_id"], name: "index_topics_on_subforum_id"
    t.index ["topic_name_translit"], name: "index_topics_on_topic_name_translit"
    t.index ["topic_show_homepage"], name: "index_topics_on_topic_show_homepage"
  end

end
