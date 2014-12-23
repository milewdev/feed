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

ActiveRecord::Schema.define(version: 20141223035455) do

  create_table "channels", force: :cascade do |t|
    t.string   "title"
    t.string   "link"
    t.string   "description"
    t.datetime "last_build_date"
    t.string   "language"
    t.string   "generator"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "feed_items", force: :cascade do |t|
    t.string   "title"
    t.string   "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "feed_items", ["guid"], name: "index_feed_items_on_guid", unique: true

  create_table "items", force: :cascade do |t|
    t.string   "title"
    t.string   "link"
    t.string   "comments"
    t.datetime "pub_date"
    t.string   "guid"
    t.string   "description"
    t.integer  "channel_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "items", ["channel_id"], name: "index_items_on_channel_id"

end
