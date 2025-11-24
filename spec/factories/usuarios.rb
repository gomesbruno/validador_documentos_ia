FactoryBot.define do
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
