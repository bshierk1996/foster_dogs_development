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

ActiveRecord::Schema.define(version: 2018_05_23_145321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dogs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "short_code"
    t.text "image_url"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birthday"
    t.boolean "urgent", default: false
    t.string "breed"
    t.integer "weight"
    t.index ["short_code"], name: "index_dogs_on_short_code", unique: true
  end

  create_table "email_logs", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "subject"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "organization"
    t.index ["user_id", "organization"], name: "index_email_logs_on_user_id_and_organization"
    t.index ["user_id", "subject"], name: "index_email_logs_on_user_id_and_subject"
    t.index ["user_id"], name: "index_email_logs_on_user_id"
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "note"
    t.string "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.uuid "uuid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_organizations_on_uuid", unique: true
  end

  create_table "outreaches", force: :cascade do |t|
    t.uuid "uuid"
    t.text "subject"
    t.integer "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_outreaches_on_uuid", unique: true
  end

  create_table "outreaches_users", id: false, force: :cascade do |t|
    t.bigint "outreach_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "dog_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_statuses_on_dog_id"
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.uuid "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fostered_before"
    t.boolean "fospice"
    t.datetime "accepted_terms_at"
    t.boolean "other_pets"
    t.boolean "kids"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "date_of_birth"
    t.text "fostered_for", default: [], array: true
    t.datetime "subscribed_at"
    t.datetime "unsubscribed_at"
    t.boolean "fosters_cats", default: false
    t.boolean "big_dogs"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

end
