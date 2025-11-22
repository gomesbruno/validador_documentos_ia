# -*- encoding : utf-8 -*-

class Pub::Vinculacao < ActiveRecord::Base
  cattr_accessor :ATIVO, :DESATIVADO

  delegate :nome, :endereco_rua, :endereco_numero, :endereco_bairro, :endereco_cep, :cidade, :ddd_telefone, :telefone,
           :ddd_celular, :celular, :email, :identidade, :identidade_orgao, :cpf, :nome,
           to: :identificacao_login

  has_one :funcionario, class_name: 'Sia::Funcionario'
  belongs_to :identificacao_login, class_name: 'Pub::IdentificacaoLogin'

  delegate :codigo, :jornada, :lotacao, :lotacao_sigla, :lotacao_exercicio,
           :atividade_funcao, to: :funcionario

  @@ATIVO = "\x01"
  @@DESATIVADO = "\x00"

  scope :ativa, -> {
    where(ativo: @@ATIVO)
  }

  def autocomplete_display_bolsista_discente
    autocomplete_display_bolsistas
  end

  def autocomplete_display_bolsista_ted
    autocomplete_display_bolsistas
  end

  def autocomplete_display_bolsistas
    "#{nome} - #{matricula}"
  end

  def tecnico?
    vinculo_id == Pub::Vinculo.TECNICO_ADMINISTRATIVO
  end

  def self.bolsista_discente(term)
    term = term.strip.tr(' ', '%')
    includes(identificacao_login: :dados_identificacao)
      .includes(:vinculo)
      .where('identificacoes_login.iduff LIKE ? OR identificacoes_login.nome LIKE ?', "%#{term}%", "%#{term}%")
      .where(vinculacoes: { vinculo_id: Pub::Vinculo::VINCULOS_ALUNOS })
      .where('vinculacoes.ativo LIKE ?', Pub::Vinculacao.ATIVO)
      .order('identificacoes_login.nome')
      .limit(150)
  end

  def self.bolsista_ted(term)
    term = term.strip.tr(' ', '%')
    joins(:funcionario)
      .includes(identificacao_login: :dados_identificacao)
      .includes(:vinculo)
      .where('identificacoes_login.iduff LIKE ? OR identificacoes_login.nome LIKE ?', "%#{term}%", "%#{term}%")
      .where(vinculacoes: { vinculo_id: Pub::Vinculo::VINCULOS_DOCENTES_TECNICOS })
      .where('vinculacoes.ativo LIKE ?', Pub::Vinculacao.ATIVO)
      .order('identificacoes_login.nome')
      .limit(150)
  end

  def self.bolsistas(term)
    todos_docentes_ted_alunos(term)
      .where('vinculacoes.ativo LIKE ?', Pub::Vinculacao.ATIVO)
      .order('identificacoes_login.nome')
      .limit(150)
  end

  def self.para_bolsistas_impedidos(term)
    todos_docentes_ted_alunos(term)
      .order('identificacoes_login.nome')
      .limit(150)
  end

  def self.todos_docentes_ted_alunos(term)
    term = term.strip.tr(' ', '%')
    left_joins(:funcionario)
      .includes(identificacao_login: :dados_identificacao)
      .includes(:vinculo)
      .where('identificacoes_login.iduff LIKE ? OR identificacoes_login.nome LIKE ?', "%#{term}%", "%#{term}%")
      .where(vinculacoes: { vinculo_id: Pub::Vinculo::VINCULOS_DOCENTES_TECNICOS + Pub::Vinculo::VINCULOS_ALUNOS })
  end
end
