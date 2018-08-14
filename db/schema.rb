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

ActiveRecord::Schema.define(version: 20180603164708) do

  create_table "comments", force: :cascade do |t|
    t.integer "player_id"
    t.string "comment_rate"
    t.text "comment_text"
    t.integer "comment_for_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_comments_on_player_id"
  end

  create_table "forums", force: :cascade do |t|
    t.string "forum_name"
    t.integer "forum_show_order", default: 1
  end

  create_table "players", force: :cascade do |t|
    t.string "player_email"
    t.string "player_nickname"
    t.string "player_nickname_translit"
    t.string "player_password"
    t.string "player_avatar", default: "noavatar.png"
    t.string "player_rank", default: "Новичек"
    t.string "player_skype_link", default: "Нет данных"
    t.string "player_vk_link", default: "Нет данных"
    t.string "player_tm_link", default: "Нет данных"
    t.string "player_discord_link", default: "Нет данных"
    t.string "player_system_messages", default: ""
    t.date "player_lastlogin"
    t.date "player_vip_expire"
    t.integer "player_sells_count", default: 0
    t.integer "player_buys_count", default: 0
    t.integer "player_votes_count", default: 0
    t.integer "player_votes_summ", default: 0
    t.integer "player_wallet", default: 0
    t.integer "player_loginfails", default: 0
    t.text "player_cart"
    t.text "player_info", default: ""
    t.boolean "player_activated", default: false
    t.boolean "player_welcomebonus", default: false
    t.boolean "player_admin", default: false
    t.boolean "player_moder", default: false
    t.boolean "player_vip", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_email"], name: "index_players_on_player_email"
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

  create_table "tarkovitems", force: :cascade do |t|
    t.integer "player_id"
    t.string "item_name"
    t.string "item_name_caps"
    t.string "item_name_translit"
    t.string "item_type", default: ""
    t.string "item_tags", default: ""
    t.string "item_barter_for", default: "0"
    t.text "item_info", default: ""
    t.text "item_message_send_by"
    t.integer "item_to_sell_count", default: 0
    t.integer "item_price_virt_rub"
    t.integer "item_price_real_rub", default: 0
    t.integer "item_price_virt_usd", default: 0
    t.integer "item_price_virt_eur", default: 0
    t.boolean "item_barter", default: false
    t.boolean "item_vip", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_barter"], name: "index_tarkovitems_on_item_barter"
    t.index ["item_name_caps"], name: "index_tarkovitems_on_item_name_caps"
    t.index ["item_price_virt_rub"], name: "index_tarkovitems_on_item_price_virt_rub"
    t.index ["item_tags"], name: "index_tarkovitems_on_item_tags"
    t.index ["item_type"], name: "index_tarkovitems_on_item_type"
    t.index ["item_vip"], name: "index_tarkovitems_on_item_vip"
    t.index ["player_id"], name: "index_tarkovitems_on_player_id"
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
