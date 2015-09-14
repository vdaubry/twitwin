# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150914021524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentication_providers", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.string   "token",      null: false
    t.string   "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "authentication_providers", ["uid"], name: "index_authentication_providers_on_uid", unique: true, using: :btree
  add_index "authentication_providers", ["user_id", "provider"], name: "index_authentication_providers_on_user_id_and_provider", unique: true, using: :btree

  create_table "tweets", force: :cascade do |t|
    t.integer  "twitter_id",       limit: 8, null: false
    t.text     "text",                       null: false
    t.string   "image_url"
    t.string   "link"
    t.string   "author_image_url",           null: false
    t.datetime "tweeted_at",                 null: false
    t.string   "language",                   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "username",                   null: false
  end

  add_index "tweets", ["image_url"], name: "index_tweets_image_on_created_at_by_month", unique: true, using: :btree
  add_index "tweets", ["text"], name: "index_tweets_on_created_at_by_day", unique: true, using: :btree
  add_index "tweets", ["tweeted_at"], name: "index_tweets_on_tweeted_at", using: :btree
  add_index "tweets", ["twitter_id"], name: "index_tweets_on_twitter_id", unique: true, using: :btree

  create_table "tweets_users", id: false, force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "tweet_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tweets_users", ["user_id", "tweet_id"], name: "index_tweets_users_on_user_id_and_tweet_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "nickname"
    t.string   "name"
    t.string   "avatar"
    t.boolean  "admin",      default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "language",   default: "en",  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
