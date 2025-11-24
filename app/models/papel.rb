class Papel < ApplicationRecord
  belongs_to :usuario
  belongs_to :perfil
end
