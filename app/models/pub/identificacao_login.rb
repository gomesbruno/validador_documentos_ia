class Pub::IdentificacaoLogin < ActiveRecord::Base
  self.table_name = 'identificacoes_login'
  has_one :dados_identificacao, class_name: 'Pub::DadosIdentificacao', foreign_key: :identificacao_login_id
  delegate :endereco_rua, :endereco_numero, :endereco_bairro, :endereco_cep, :cidade,
           :ddd_telefone, :telefone, :ddd_celular, :celular, :email, :identidade, :identidade_orgao, :cpf,
           :estado_civil,
           to: :dados_identificacao
  delegate :vinculacao_id, to: :vinculacoes

  has_one :usuario, inverse_of: :identificacao_login

  scope :ativo, -> { joins(:vinculacoes).where(vinculacoes: { ativo: "\x01" }) }

  scope :por_nome, lambda { |nome|
                     where('identificacoes_login.iduff LIKE ? OR identificacoes_login.nome LIKE ?',
                           "%#{nome.tr(' ', '%')}%", "%#{nome.tr(' ', '%')}%")
                   }

  scope :por_lotacao, lambda { |lotacao_id|
                        joins(vinculacoes: :funcionario)
                          .where(vinculacoes: { funcionarios: { lotacao_exercicio_id: lotacao_id } })
                      }

  scope :ativo_por_nome_ou_iduff, lambda { |termo|
    joins(:vinculacoes)
      .ativo
      .por_nome(termo)
      .order(:nome)
      .distinct
  }

  scope :assistente_valido, lambda { |termo, limit|
    joins(:vinculacoes)
      .where("vinculacoes.vinculo_id <> #{Pub::Vinculo.ALUNO}")
      .por_nome(termo)
      .order(:nome)
      .distinct.limit(limit / 2) +
      ativo_por_nome_ou_iduff(termo).where("vinculacoes.vinculo_id = #{Pub::Vinculo.ALUNO}").limit(limit / 2)
  }

  scope :ativo_por_nome_e_lotacao, lambda { |term, lotacao_id|
    por_lotacao(lotacao_id)
      .ativo
      .por_nome(term)
      .distinct
  }

  scope :podem_ser_coordenador_ou_fiscal, lambda { |termo|
    ativo_por_nome_ou_iduff(termo).where(
      vinculacoes: {
        vinculo_id: [
          Pub::Vinculo.PROFESSOR,
          Pub::Vinculo.PROFESSOR_SUBSTITUTO,
          Pub::Vinculo.TECNICO_ADMINISTRATIVO
        ]
      }
    )
                                  .distinct
  }

  def self.get_schema_publico
    PublicoCore.db_config['database']
  end

  def funcionarios
    vinculacoes.ativa.joins(:funcionario).includes(:funcionario).map(&:funcionario).compact
  end

  def todos_funcionarios
    vinculacoes.joins(:funcionario).includes(:funcionario).map(&:funcionario).compact
  end

  def autocomplete_display
    "#{nome} - #{iduff}"
  end

  def autocomplete_display_bolsista_discente
    "#{nome} - #{vinculacoes.first.matricula}"
  end

  def foto
    "https://sistemas.uff.br/static/identificacoes/oficial/#{Digest::SHA1.hexdigest(iduff.to_s)}.jpg"
  end

  def cargos
    vinculacoes.ativa.joins(funcionario: :cargo).includes(funcionario: :cargo)
               .map(&:funcionario).map(&:cargo)
  end

  def atividades_funcoes
    vinculacoes.ativa.joins(funcionario: :atividade_funcao)
               .includes(funcionario: :atividade_funcao)
               .where.not(funcionario: { atividades_funcoes: { id: 0 } }).map(&:atividade_funcao).compact
  end

  def lotacao_exercicio
    return unless funcionarios

    funcionarios.map(&:lotacao_exercicio_id).first
  end
end
