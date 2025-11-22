class CreateUsuarios < ActiveRecord::Migration[6.1]
  def change
    create_table :usuarios do |t|

      t.bigint  :user_id, null: false                     # id do usuário no banco público
      t.bigint  :identificacao_login_id, null: false      # id em tabela pública
      t.datetime :data_desativacao

      t.timestamps
    end

    add_index :usuarios, :user_id
    add_index :usuarios, :identificacao_login_id
    add_index :usuarios, [:user_id, :identificacao_login_id], unique: true, name: "idx_usuarios_user_ident"
  end
end
