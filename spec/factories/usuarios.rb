FactoryBot.define do
  factory :identificacao_login, class: 'Pub::IdentificacaoLogin' do
    sequence(:nome) { |n| "Usuario #{n}" }
    sequence(:iduff) { |n| "iduff#{n}" }
  end

  factory :dados_identificacao, class: 'Pub::DadosIdentificacao' do
    cpf { '12345678900' }
    association :identificacao_login, factory: :identificacao_login
  end

  factory :perfil do
    sequence(:tipo) { |n| "perfil_#{n}" }
  end

  factory :usuario do
    sequence(:user_id)
    association :identificacao_login, factory: :identificacao_login
  end

  factory :papel do
    association :usuario
    association :perfil
  end
end
