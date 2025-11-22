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

ActiveRecord::Schema.define(version: 2025_11_10_031028) do

  create_table "usuarios", charset: "latin1", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "identificacao_login_id", null: false
    t.datetime "data_desativacao"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identificacao_login_id"], name: "index_usuarios_on_identificacao_login_id"
    t.index ["user_id", "identificacao_login_id"], name: "idx_usuarios_user_ident", unique: true
    t.index ["user_id"], name: "index_usuarios_on_user_id"
  end

  create_table "versions", charset: "utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
