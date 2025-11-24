FactoryBot.define do
  factory :identificacao_login, class: 'Pub::IdentificacaoLogin' do
    sequence(:nome) { |n| "Fulano da Silva #{n}" }
    sequence(:iduff) { |id| 100 + id }
    dados_identificacao

    factory :identificacao_login_docente do
      after(:create) do |id|
        create(:vinculacao, :ted, identificacao_login: id)
        if Pub::Vinculo.find_by(id: 2)
          id.vinculacoes.first.update_attribute(:vinculo_id, 2)
        else
          create(:vinculo, id: 2)
          id.vinculacoes.first.update_attribute(:vinculo_id, 2)
        end
      end

      trait :com_lotacao_real do
        transient do
          # sigla padrão da trait, caso queira mudar use:
          # create(:identificacao_login_docente, :com_lotacao_real, sigla: 'nome_desejado')
          sigla { 'STI' }
        end
        after(:create) do |id, evaluator|
          funcionario = id.funcionarios.first
          if funcionario.present?
            if funcionario.lotacao_exercicio.present?
              funcionario.lotacao_exercicio.update_attribute(:sigla, evaluator.sigla)
            else
              lotacao = create(:orgao, sigla: evaluator.sigla)
              situacao = Sia::Situacao.find_or_create_by({ id: 1, codigo: 'codigo', descricao: 'descricao' })
              funcionario.lotacao_exercicio = lotacao
              funcionario.situacao = situacao
            end
            funcionario.save(validate: false)
          else
            lotacao = create(:orgao, sigla: evaluator.sigla)
            situacao = Sia::Situacao.find_or_create_by({ id: 1, codigo: 'codigo', descricao: 'descricao' })
            funcionario = create(:funcionario, situacao: situacao, lotacao_exercicio_id: lotacao.uorg,
                                 sigla_chefia: 'FG', nivel_chefia: '3', vinculacao_id: id.vinculacoes.first.id)
            funcionario.vinculacao_id = id.vinculacoes.last.id
            funcionario.save(validate: false)
          end
        end
      end
    end

    factory :identificacao_login_discente do
      after(:create) do |id|
        create(:vinculacao, identificacao_login: id)
        if Pub::Vinculo.find_by(id: 1)
          id.vinculacoes.first.update_attribute(:vinculo_id, 1)
        else
          create(:vinculo, id: 1)
          id.vinculacoes.first.update_attribute(:vinculo_id, 1)
        end
      end
    end

    factory :identificacao_login_presidente_fec do
      after(:create) do |id|
        create(:vinculacao, identificacao_login: id)
        if Pub::Vinculo.find_by(id: 2)
          id.vinculacoes.first.update_attribute(:vinculo_id, 2)
        else
          create(:vinculo, id: 2)
          id.vinculacoes.first.update_attribute(:vinculo_id, 2)
        end
      end
    end

    factory :identificacao_tecnico_administrativo do
      after(:create) do |id|
        create(:vinculacao, identificacao_login: id)
        if Pub::Vinculo.find_by(id: 4)
          id.vinculacoes.first.update_attribute(:vinculo_id, 4)
        else
          create(:vinculo, id: 4)
          id.vinculacoes.first.update_attribute(:vinculo_id, 4)
        end
      end
    end

  end
end
