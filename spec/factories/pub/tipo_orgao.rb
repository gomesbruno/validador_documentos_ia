FactoryBot.define do
  factory :tipo_orgao, class: Pub::TipoOrgao do
    sequence(:id) { |n| 777 + n }
    to_create do |instance|
      instance.id = Pub::TipoOrgao.where(id: instance.id).first_or_create(instance.attributes).id
      instance.reload
    end
  end
end
