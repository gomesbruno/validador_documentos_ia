FactoryBot.define do
  factory :localidade, class: 'Pub::Localidade' do
    sequence(:nome) { |n| "Localidade #{n}" }
    sigla { Faker::Alphanumeric.unique.alphanumeric(number: 3) }
    sequence(:codigo) { |n| 777 + n }
    cidade

    to_create do |instance|
      instance.id = Pub::Localidade.where(sigla: instance.sigla)
                                   .or(Pub::Localidade.where(codigo: instance.codigo))
                                   .first_or_create(instance.attributes).id
      instance.reload
    end
  end
end