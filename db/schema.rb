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

ActiveRecord::Schema.define(version: 20161111085743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "directories", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_directories_on_name", using: :btree
    t.index ["user_id"], name: "index_directories_on_user_id", using: :btree
  end

  create_table "directory_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "directory_anc_desc_idx", unique: true, using: :btree
    t.index ["descendant_id"], name: "directory_desc_idx", using: :btree
  end

  create_table "links", force: :cascade do |t|
    t.integer  "directory_id"
    t.string   "name"
    t.string   "destination"
    t.integer  "ttl",          default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["directory_id"], name: "index_links_on_directory_id", using: :btree
    t.index ["name"], name: "index_links_on_name", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "identifiable_claim"
    t.integer  "directory_id"
    t.string   "email"
    t.string   "name"
    t.string   "friendly_name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["directory_id"], name: "index_users_on_directory_id", using: :btree
    t.index ["friendly_name"], name: "index_users_on_friendly_name", unique: true, using: :btree
    t.index ["identifiable_claim"], name: "index_users_on_identifiable_claim", unique: true, using: :btree
  end

end
