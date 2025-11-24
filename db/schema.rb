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

ActiveRecord::Schema.define(version: 2025_11_10_032000) do

  create_table "cidades", charset: "utf8mb4", force: :cascade do |t|
    t.string "nome"
    t.bigint "estado_id"
    t.integer "codigo_ibge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["estado_id"], name: "index_cidades_on_estado_id"
  end

  create_table "dados_identificacoes", charset: "utf8mb4", force: :cascade do |t|
    t.string "nome_abreviado"
    t.string "iduff_mail"
    t.bigint "pais_nacionalidade_id"
    t.bigint "nacionalidade_id"
    t.bigint "endereco_cidade_id"
    t.bigint "identidade_estado_id"
    t.bigint "naturalidade_estado_id"
    t.bigint "identificacao_login_id"
    t.string "endereco_rua"
    t.string "endereco_numero"
    t.string "endereco_bairro"
    t.string "endereco_cep"
    t.string "ddd_telefone"
    t.string "telefone"
    t.string "ddd_celular"
    t.string "celular"
    t.string "email"
    t.string "identidade"
    t.string "identidade_orgao"
    t.string "cpf"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["endereco_cidade_id"], name: "index_dados_identificacoes_on_endereco_cidade_id"
    t.index ["identidade_estado_id"], name: "index_dados_identificacoes_on_identidade_estado_id"
    t.index ["identificacao_login_id"], name: "index_dados_identificacoes_on_identificacao_login_id"
    t.index ["nacionalidade_id"], name: "index_dados_identificacoes_on_nacionalidade_id"
    t.index ["naturalidade_estado_id"], name: "index_dados_identificacoes_on_naturalidade_estado_id"
    t.index ["pais_nacionalidade_id"], name: "index_dados_identificacoes_on_pais_nacionalidade_id"
  end

  create_table "estados", charset: "utf8mb4", force: :cascade do |t|
    t.string "nome"
    t.string "sigla"
    t.bigint "pais_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pais_id"], name: "index_estados_on_pais_id"
  end

  create_table "identificacoes_login", charset: "utf8mb4", force: :cascade do |t|
    t.string "nome"
    t.string "iduff"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "papeis", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "usuario_id"
    t.bigint "perfil_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["perfil_id"], name: "index_papeis_on_perfil_id"
    t.index ["usuario_id"], name: "index_papeis_on_usuario_id"
  end

  create_table "paises", charset: "utf8mb4", force: :cascade do |t|
    t.string "nome"
    t.string "sigla"
    t.integer "codigo"
    t.string "nacionalidade"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "perfis", charset: "utf8mb4", force: :cascade do |t|
    t.string "tipo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

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
