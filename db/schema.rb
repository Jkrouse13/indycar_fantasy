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

ActiveRecord::Schema[8.1].define(version: 2026_05_01_022516) do
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
    t.boolean "active", default: true, null: false
    t.string "car_number"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "primary_color"
    t.string "secondary_color"
    t.bigint "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_drivers_on_team_id"
  end

  create_table "fast_twelve_picks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "driver_id", null: false
    t.bigint "qualifying_prediction_id", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_fast_twelve_picks_on_driver_id"
    t.index ["qualifying_prediction_id", "driver_id"], name: "idx_on_qualifying_prediction_id_driver_id_45ceb850c4", unique: true
    t.index ["qualifying_prediction_id"], name: "index_fast_twelve_picks_on_qualifying_prediction_id"
  end

  create_table "last_row_picks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "driver_id", null: false
    t.bigint "qualifying_prediction_id", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_last_row_picks_on_driver_id"
    t.index ["qualifying_prediction_id", "driver_id"], name: "index_last_row_picks_on_qualifying_prediction_id_and_driver_id", unique: true
    t.index ["qualifying_prediction_id"], name: "index_last_row_picks_on_qualifying_prediction_id"
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

  create_table "qualifying_predictions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "participant_id", null: false
    t.bigint "pole_pick_driver_id"
    t.boolean "saturday_wreck", default: false, null: false
    t.boolean "sunday_wreck", default: false, null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.index ["participant_id", "year"], name: "index_qualifying_predictions_on_participant_id_and_year", unique: true
    t.index ["participant_id"], name: "index_qualifying_predictions_on_participant_id"
    t.index ["pole_pick_driver_id"], name: "index_qualifying_predictions_on_pole_pick_driver_id"
  end

  create_table "qualifying_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "finalized", default: false, null: false
    t.bigint "pole_driver_id"
    t.boolean "saturday_wreck", default: false, null: false
    t.boolean "sunday_wreck", default: false, null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.index ["pole_driver_id"], name: "index_qualifying_results_on_pole_driver_id"
    t.index ["year"], name: "index_qualifying_results_on_year", unique: true
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

  create_table "result_fast_twelves", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "driver_id", null: false
    t.bigint "qualifying_result_id", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_result_fast_twelves_on_driver_id"
    t.index ["qualifying_result_id", "driver_id"], name: "idx_on_qualifying_result_id_driver_id_621dc88fb7", unique: true
    t.index ["qualifying_result_id"], name: "index_result_fast_twelves_on_qualifying_result_id"
  end

  create_table "result_last_rows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "driver_id", null: false
    t.bigint "qualifying_result_id", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_result_last_rows_on_driver_id"
    t.index ["qualifying_result_id", "driver_id"], name: "index_result_last_rows_on_qualifying_result_id_and_driver_id", unique: true
    t.index ["qualifying_result_id"], name: "index_result_last_rows_on_qualifying_result_id"
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
  add_foreign_key "fast_twelve_picks", "drivers"
  add_foreign_key "fast_twelve_picks", "qualifying_predictions"
  add_foreign_key "last_row_picks", "drivers"
  add_foreign_key "last_row_picks", "qualifying_predictions"
  add_foreign_key "picks", "drivers"
  add_foreign_key "picks", "participants"
  add_foreign_key "picks", "race_tiers"
  add_foreign_key "picks", "races"
  add_foreign_key "qualifying_predictions", "drivers", column: "pole_pick_driver_id"
  add_foreign_key "qualifying_predictions", "participants"
  add_foreign_key "qualifying_results", "drivers", column: "pole_driver_id"
  add_foreign_key "race_results", "drivers"
  add_foreign_key "race_results", "races"
  add_foreign_key "race_tiers", "races"
  add_foreign_key "result_fast_twelves", "drivers"
  add_foreign_key "result_fast_twelves", "qualifying_results"
  add_foreign_key "result_last_rows", "drivers"
  add_foreign_key "result_last_rows", "qualifying_results"
  add_foreign_key "tier_drivers", "drivers"
  add_foreign_key "tier_drivers", "race_tiers"
end
