class Perfil < ApplicationRecord
  has_many :papeis, inverse_of: :perfil, dependent: :destroy
  has_many :usuarios, through: :papeis
end
