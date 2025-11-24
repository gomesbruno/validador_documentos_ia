FactoryBot.define do
  factory :estado, class: 'Pub::Estado' do
    sequence(:nome) { |n| "Estado #{n}" }
    sigla { 'ET' }
    pais
  end
end
