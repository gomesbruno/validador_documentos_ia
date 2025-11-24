unless defined?(Perfil)
  class Perfil < ApplicationRecord
    scope :coordenador, -> { where(tipo: 'coordenador') }
    scope :assistente, -> { where(tipo: 'assistente') }
    scope :fiscal, -> { where(tipo: 'fiscal') }
  end
end

unless defined?(Papel)
  class Papel < ApplicationRecord
    belongs_to :usuario
    belongs_to :perfil
  end
end

unless defined?(Pub::DadosIdentificacao)
  class Pub::DadosIdentificacao < ApplicationRecord
    self.table_name = 'dados_identificacoes'

    belongs_to :identificacao_login, class_name: 'Pub::IdentificacaoLogin'
  end
end

unless Usuario.method_defined?(:papeis)
  Usuario.class_eval do
    has_many :papeis, dependent: :destroy
    has_many :perfis, through: :papeis
  end
end
