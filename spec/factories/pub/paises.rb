FactoryBot.define do
  factory :pais, class: 'Pub::Pais' do
    sequence(:nome) { |n| "Pais #{n}" }
    sigla { 'PA' }
    sequence(:codigo) { |n| n }
    sequence(:nacionalidade) { |n| "Pais#{n}" }
  end
end
