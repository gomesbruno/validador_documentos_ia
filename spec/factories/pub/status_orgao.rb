FactoryBot.define do
  factory :status_orgao, class: Pub::StatusOrgao do
    sequence(:id) { |n| 777 + n }
    to_create do |instance|
      instance.id = Pub::StatusOrgao.where(id:  instance.id).first_or_create(instance.attributes).id
      instance.reload
    end
  end
end
