# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_31_151143) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cases", force: :cascade do |t|
    t.integer "total_cases"
    t.integer "new_cases"
    t.integer "total_deaths"
    t.integer "new_deaths"
    t.integer "population"
    t.integer "total_tests"
    t.integer "new_tests"
    t.integer "tests_per_case"
    t.integer "stringency_index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "indications", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.text "open"
    t.text "quarantine"
    t.text "test"
    t.string "group_size_public"
    t.string "masks_in_public"
    t.string "tourism_accomodations"
    t.string "restaurants"
    t.string "bars_cafes"
    t.string "beaches"
    t.string "museums"
    t.string "personal_services"
    t.string "places_of_worship"
    t.string "physical_distancing"
    t.string "health_protocols"
    t.string "public_transportation"
    t.string "gatherings"
    t.string "high_risk_areas"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_indications_on_country_id"
  end

  create_table "trips", force: :cascade do |t|
    t.bigint "origin_id", null: false
    t.bigint "destination_id", null: false
    t.bigint "user_id", null: false
    t.boolean "bookmarked"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["destination_id"], name: "index_trips_on_destination_id"
    t.index ["origin_id"], name: "index_trips_on_origin_id"
    t.index ["user_id"], name: "index_trips_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "home_country"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "indications", "countries"
  add_foreign_key "trips", "countries", column: "destination_id"
  add_foreign_key "trips", "countries", column: "origin_id"
  add_foreign_key "trips", "users"
end
