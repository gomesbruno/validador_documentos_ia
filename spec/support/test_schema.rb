RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Schema.define do
      unless ActiveRecord::Base.connection.table_exists?(:identificacoes_login)
        create_table :identificacoes_login do |t|
          t.string :nome
          t.string :iduff
          t.timestamps
        end
      end

      unless ActiveRecord::Base.connection.table_exists?(:dados_identificacoes)
        create_table :dados_identificacoes do |t|
          t.references :identificacao_login, null: false
          t.string :cpf
          t.timestamps
        end
      end

      unless ActiveRecord::Base.connection.table_exists?(:perfis)
        create_table :perfis do |t|
          t.string :tipo, null: false
          t.timestamps
        end
      end

      unless ActiveRecord::Base.connection.table_exists?(:papeis)
        create_table :papeis do |t|
          t.references :usuario, null: false
          t.references :perfil, null: false
          t.timestamps
        end
      end
    end
  end
end
