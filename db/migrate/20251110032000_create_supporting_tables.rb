class CreateSupportingTables < ActiveRecord::Migration[6.1]
  def change
    create_table :paises do |t|
      t.string :nome
      t.string :sigla
      t.integer :codigo
      t.string :nacionalidade

      t.timestamps
    end

    create_table :estados do |t|
      t.string :nome
      t.string :sigla
      t.references :pais, foreign_key: { to_table: :paises }

      t.timestamps
    end

    create_table :cidades do |t|
      t.string :nome
      t.references :estado, foreign_key: { to_table: :estados }
      t.integer :codigo_ibge

      t.timestamps
    end

    create_table :identificacoes_login do |t|
      t.string :nome
      t.string :iduff

      t.timestamps
    end

    create_table :dados_identificacoes do |t|
      t.string :nome_abreviado
      t.string :iduff_mail
      t.references :pais_nacionalidade, foreign_key: { to_table: :paises }
      t.references :nacionalidade, foreign_key: { to_table: :paises }
      t.references :endereco_cidade, foreign_key: { to_table: :cidades }
      t.references :identidade_estado, foreign_key: { to_table: :estados }
      t.references :naturalidade_estado, foreign_key: { to_table: :estados }
      t.references :identificacao_login, foreign_key: { to_table: :identificacoes_login }
      t.string :endereco_rua
      t.string :endereco_numero
      t.string :endereco_bairro
      t.string :endereco_cep
      t.string :ddd_telefone
      t.string :telefone
      t.string :ddd_celular
      t.string :celular
      t.string :email
      t.string :identidade
      t.string :identidade_orgao
      t.string :cpf

      t.timestamps
    end

    create_table :perfis do |t|
      t.string :tipo

      t.timestamps
    end

    create_table :papeis do |t|
      t.references :usuario, foreign_key: true
      t.references :perfil, foreign_key: true

      t.timestamps
    end
  end
end
