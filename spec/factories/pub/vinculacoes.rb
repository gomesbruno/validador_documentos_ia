FactoryBot.define do
  factory :vinculacao, class: 'Pub::Vinculacao' do
    sequence(:matricula) { |n| 1000000000 + n }
    identificacao_login
    vinculo
    ativo { "\x01" }
    localidade

    trait :discente do
      after(:create) do |vinculacao|
        if Pub::Vinculo.find_by(id: 1)
          vinculacao.update_attribute(:vinculo_id, 1)
        else
          create(:vinculo, id: 1)
          vinculacao.update_attribute(:vinculo_id, 1)
        end
      end
    end

    trait :ted do
      after(:create) do |vinculacao|
       create(:funcionario, vinculacao: vinculacao)
        if Pub::Vinculo.find_by(id: 2)
          vinculacao.update_attribute(:vinculo_id, 2)
        else
          create(:vinculo, id: 2)
          vinculacao.update_attribute(:vinculo_id, 2)
        end
      end
    end

    trait :tecnico do
      after(:create) do |vinculacao|
       create(:funcionario, vinculacao: vinculacao)
        if Pub::Vinculo.find_by(id: 4)
          vinculacao.update_attribute(:vinculo_id, 4)
        else
          create(:vinculo, id: 4)
          vinculacao.update_attribute(:vinculo_id, 4)
        end
      end
    end
  end
end
