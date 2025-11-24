class Pub::Estado < ActiveRecord::Base
  belongs_to :pais, class_name: 'Pub::Pais'
end
