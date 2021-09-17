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

ActiveRecord::Schema.define(version: 0) do

  create_table "categories", id: { type: :integer, limit: 1, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "programs", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "s3_key", null: false
    t.date "on_air", null: false
    t.integer "already_play", limit: 1, default: 0, null: false, unsigned: true
    t.integer "category_id", limit: 1, null: false, unsigned: true
    t.index ["category_id"], name: "category_id"
    t.index ["s3_key"], name: "s3_key", unique: true
  end

  create_table "users", id: { type: :integer, limit: 1, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "encrypt_email", null: false
    t.string "encrypt_password", null: false
    t.index ["encrypt_email"], name: "encrypt_email", unique: true
  end

  add_foreign_key "programs", "categories", name: "programs_ibfk_1"
end
