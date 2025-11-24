FactoryBot.define do
  factory :cidade, class: 'Pub::Cidade' do
    sequence(:nome) { |n| "Cidade #{n}" }
    estado
  end
end
