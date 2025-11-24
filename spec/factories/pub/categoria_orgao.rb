FactoryBot.define do
  factory :categoria_orgao, class: Pub::CategoriaOrgao do
    sequence(:id) { |n| 777 + n }
    sequence(:descricao) { |n| "CategoriaOrgao#{n}" }

    to_create do |instance|
      instance.id = Pub::CategoriaOrgao.where(id: instance.id).first_or_create(instance.attributes).id
      instance.reload
    end
  end
end
