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

ActiveRecord::Schema.define(version: 20180601095624) do

  create_table "forums", force: :cascade do |t|
    t.string "forum_name"
    t.string "forum_name_translit"
    t.string "forum_icon"
  end

  create_table "players", force: :cascade do |t|
    t.string "player_email"
    t.string "player_avatar"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "topic_id"
    t.integer "player_id"
    t.string "post_text"
    t.string "post_name_caps"
    t.string "post_name_translit"
    t.index ["player_id"], name: "index_posts_on_player_id"
    t.index ["topic_id"], name: "index_posts_on_topic_id"
  end

  create_table "subforums", force: :cascade do |t|
    t.integer "forum_id"
    t.string "subforum_name"
    t.string "subforum_name_translit"
    t.index ["forum_id"], name: "index_subforums_on_forum_id"
  end

  create_table "topics", force: :cascade do |t|
    t.integer "subforum_id"
    t.integer "player_id"
    t.string "topic_name"
    t.string "topic_name_caps"
    t.string "topic_name_translit"
    t.string "topic_icon"
    t.boolean "topic_show_homepage"
    t.boolean "topic_pinned"
    t.index ["player_id"], name: "index_topics_on_player_id"
    t.index ["subforum_id"], name: "index_topics_on_subforum_id"
  end

end
