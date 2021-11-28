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

ActiveRecord::Schema.define(version: 2021_11_27_220010) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alliances", force: :cascade do |t|
    t.datetime "esi_expires_at", null: false
    t.datetime "esi_last_modified_at", null: false
    t.text "icon_url_128"
    t.text "icon_url_64"
    t.text "name", null: false
    t.text "ticker", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "characters", force: :cascade do |t|
    t.bigint "alliance_id"
    t.bigint "corporation_id", null: false
    t.datetime "esi_expires_at", null: false
    t.datetime "esi_last_modified_at", null: false
    t.text "name", null: false
    t.text "portrait_url_128"
    t.text "portrait_url_256"
    t.text "portrait_url_512"
    t.text "portrait_url_64"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alliance_id"], name: "index_characters_on_alliance_id"
    t.index ["corporation_id"], name: "index_characters_on_corporation_id"
  end

  create_table "corporations", force: :cascade do |t|
    t.bigint "alliance_id"
    t.datetime "esi_expires_at", null: false
    t.datetime "esi_last_modified_at", null: false
    t.text "icon_url_128"
    t.text "icon_url_256"
    t.text "icon_url_64"
    t.text "name", null: false
    t.text "ticker", null: false
    t.text "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alliance_id"], name: "index_corporations_on_alliance_id"
  end

  create_table "esi_authorizations", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "user_id", null: false
    t.text "access_token_ciphertext", null: false
    t.datetime "expires_at", null: false
    t.text "refresh_token_ciphertext", null: false
    t.text "scopes", default: [], null: false, array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_esi_authorizations_on_character_id"
    t.index ["user_id"], name: "index_esi_authorizations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_users_on_character_id"
  end

  add_foreign_key "characters", "alliances"
  add_foreign_key "characters", "corporations"
  add_foreign_key "corporations", "alliances"
  add_foreign_key "esi_authorizations", "characters"
  add_foreign_key "esi_authorizations", "users"
  add_foreign_key "users", "characters"
end
