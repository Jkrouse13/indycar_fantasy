# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_01_213036) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "drivers", force: :cascade do |t|
    t.integer "car_number"
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_drivers_on_team_id"
  end

  create_table "participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "picks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "driver_id", null: false
    t.bigint "participant_id", null: false
    t.bigint "race_id", null: false
    t.bigint "race_tier_id", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_picks_on_driver_id"
    t.index ["participant_id"], name: "index_picks_on_participant_id"
    t.index ["race_id"], name: "index_picks_on_race_id"
    t.index ["race_tier_id"], name: "index_picks_on_race_tier_id"
  end

  create_table "race_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "driver_id", null: false
    t.integer "finishing_position"
    t.bigint "race_id", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_race_results_on_driver_id"
    t.index ["race_id"], name: "index_race_results_on_race_id"
  end

  create_table "race_tiers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "race_id", null: false
    t.integer "tier_number"
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_race_tiers_on_race_id"
  end

  create_table "races", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date"
    t.datetime "green_flag_time"
    t.string "name"
    t.integer "season_year"
    t.integer "status"
    t.string "track"
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "tier_drivers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "driver_id", null: false
    t.bigint "race_tier_id", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_tier_drivers_on_driver_id"
    t.index ["race_tier_id"], name: "index_tier_drivers_on_race_tier_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "drivers", "teams"
  add_foreign_key "picks", "drivers"
  add_foreign_key "picks", "participants"
  add_foreign_key "picks", "race_tiers"
  add_foreign_key "picks", "races"
  add_foreign_key "race_results", "drivers"
  add_foreign_key "race_results", "races"
  add_foreign_key "race_tiers", "races"
  add_foreign_key "tier_drivers", "drivers"
  add_foreign_key "tier_drivers", "race_tiers"
end
