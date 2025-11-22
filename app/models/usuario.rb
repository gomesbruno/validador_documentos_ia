class Usuario < ApplicationRecord

  belongs_to :identificacao_login, class_name: 'Pub::IdentificacaoLogin',inverse_of: :usuario

  validates :identificacao_login, presence: true, uniqueness: {message: 'Cadastro Inválido! Usuário já existe.'}

  delegate :email, to: :identificacao_login
  delegate :nome, :iduff, :autocomplete_display, :foto, to: :identificacao_login, allow_nil: true

  scope :por_iduff, ->(iduff) {
    joins(:identificacao_login)
      .where(identificacoes_login: {iduff: iduff})
  }
  scope :por_iduff_ou_nome, ->(term) {
    joins(:identificacao_login)
      .where('identificacoes_login.iduff LIKE ? OR identificacoes_login.nome LIKE ?', "%#{term}%", "%#{term}%")
  }
  scope :por_identificacao_login_id, ->(id) {
    joins(:identificacao_login)
      .where(identificacoes_login: {id: id})
  }

  def self.cria_usuario(identificacao_login)
    cria_sem_validar(identificacao_login)
  end

  def self.cria_sem_validar(identificacao_login_id)
    usuario = Usuario.find_by(identificacao_login_id: identificacao_login_id)
    if usuario.blank?
      usuario = Usuario.new(identificacao_login_id: identificacao_login_id)
      usuario.ignora_vinculo= true
      usuario.save!
    end
    usuario
  end

  def self.cria_perfil(identificacao_login, perfil)
    @usuario = nil
    if %w[administrador assistente observador].include? perfil.tipo
      @usuario = cria_sem_validar(identificacao_login)
    else
      @usuario = Usuario.find_or_create_by!(identificacao_login_id: identificacao_login)
    end
    @usuario.papeis.create!(perfil: perfil) unless @usuario.papeis.map(&:perfil).include?(perfil)
    @usuario
  end

  def self.cria_assistente(identificacao_login_id)
    usuario = cria_sem_validar(identificacao_login_id)
    perfil = Perfil.assistente.first
    usuario.papeis.create!(perfil: perfil) unless usuario.papeis.map(&:perfil).include?(perfil)
    usuario
  end



end
