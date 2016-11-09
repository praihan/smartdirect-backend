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

ActiveRecord::Schema.define(version: 20161105012917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "ltree"

  create_table "directories", force: :cascade do |t|
    t.integer  "link_system_id"
    t.ltree    "path"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["link_system_id", "path"], name: "index_directories_on_link_system_id_and_path", using: :btree
    t.index ["link_system_id"], name: "index_directories_on_link_system_id", using: :btree
  end

  create_table "link_systems", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_link_systems_on_user_id", using: :btree
  end

  create_table "links", force: :cascade do |t|
    t.integer  "directory_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["directory_id"], name: "index_links_on_directory_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "identifiable_claim"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["identifiable_claim"], name: "index_users_on_identifiable_claim", unique: true, using: :btree
  end

end
