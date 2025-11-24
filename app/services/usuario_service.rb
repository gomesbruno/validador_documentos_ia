class UsuarioService < ApplicationService
  def self.criar_novo_coordenador(identificacao_login)
    usuario = Usuario.por_iduff(identificacao_login.iduff).first
    if usuario.blank? || !usuario.try(:perfis).try(:include?, Perfil.coordenador.first)
      usuario = Usuario.cria_perfil(identificacao_login.id,
                                                Perfil.coordenador.first)
    end
    usuario
  end

  def self.criar_novo_assistente(identificacao_login)
    usuario = Usuario.por_iduff(identificacao_login.iduff).first
    if usuario.blank? || !usuario.try(:perfis).try(:include?, Perfil.assistente.first)
      usuario = Usuario.cria_perfil(identificacao_login.id,
                                                Perfil.assistente.first)
    end
    usuario
  end

  def self.criar_usuario(identificacao_login_id, perfis_selecionados)
    transacional({notice: 'Usuário criado com sucesso!'}) do
      usuario = Usuario.cria_usuario(identificacao_login_id)
      associar_perfis usuario, perfis_selecionados if perfis_selecionados.present?
      usuario
    end
  end

  def self.modifica_perfil(usuario, perfis_selecionados)
    transacional({notice: 'Usuário modificado com sucesso!'}) do
      perfis_a_remover = Perfil.all.pluck(:id) - perfis_selecionados.map(&:to_i)
      associar_perfis usuario, perfis_selecionados
      remover_perfis usuario, perfis_a_remover
    end
  end

  def self.criar_novo_fiscal(identificacao_login)
    return if usuario_fiscal_existe?(identificacao_login.id)

    criar_usuario(identificacao_login.id, [Perfil.fiscal.first.id, Perfil.coordenador.first.id])
  end

  def self.desativar_usuario(usuario)
    transacional({ notice: 'Usuário desativado com sucesso!' }) do
      usuario.desativar!
    end
  end

  def self.reativar_usuario(usuario)
    transacional({ notice: 'Usuário reativado com sucesso!' }) do
      usuario.reativar!
    end
  end

  private

  def self.associar_perfis(usuario, perfis)
    perfis.each do |perfil|
      Usuario.cria_perfil(usuario.identificacao_login.id,
                                      Perfil.find(perfil))
    end
  end

  def self.remover_perfis(usuario, perfis)
    perfis.each do |perfil|
      papel = Papel.find_by(usuario_id: usuario.id, perfil_id: perfil)
      papel.delete if papel.present?
    end
  end

  def self.usuario_fiscal_existe?(identificacao_login_id)
    usuario = Usuario.por_identificacao_login_id(identificacao_login_id).first
    return false unless usuario.present?
    perfis = usuario.perfis.pluck(:tipo).map(&:to_sym)
    usuario.present? && perfis.include?(:fiscal)
  end
end
