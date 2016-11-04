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

ActiveRecord::Schema.define(version: 20161104183234) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "link_directories", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft",        null: false
    t.integer  "rgt",        null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lft"], name: "index_link_directories_on_lft", using: :btree
    t.index ["parent_id"], name: "index_link_directories_on_parent_id", using: :btree
    t.index ["rgt"], name: "index_link_directories_on_rgt", using: :btree
    t.index ["user_id"], name: "index_link_directories_on_user_id", using: :btree
  end

  create_table "links", force: :cascade do |t|
    t.integer  "link_directory_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["link_directory_id"], name: "index_links_on_link_directory_id", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "identifiable_claim"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "link_directory_id"
    t.index ["identifiable_claim"], name: "index_users_on_identifiable_claim", unique: true, using: :btree
  end

end
