FactoryBot.define do
  factory :vinculo, class: 'Pub::Vinculo' do
    sequence(:descricao) { |n| "Vinculo #{n}" }
    trait :discente do
      id { 1 }
    end

    trait :ted do
      id { 2 }
    end

    to_create do |instance|
      instance.id = Pub::Vinculo.where(descricao: instance.descricao).first_or_create(instance.attributes).id
      instance.reload
    end
  end
end
