FactoryBot.define do
  factory :orgao, class: 'Pub::Orgao' do
    sequence(:id) {|n| 777300 + n}
    sequence(:descricao) {|n| "Orgão #{n}"}
    sequence(:sigla) {|n| "ORG#{n}"}
    sequence(:email) {|n| "unidade#{n}@teste.com"}
    sequence(:uorg) {|n| "11#{n}"}
    tipo_orgao
    status_orgao
    categoria_orgao
    ancestrais {'1/10462'}
    trait :com_orgao_pai do
      association :orgao_pai, factory: :orgao
    end

    to_create do |instance|
      instance.id = Pub::Orgao.where(id: instance.id).first_or_create(instance.attributes).id
      instance.reload
    end
  end
end
