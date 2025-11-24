module UsuariosHelper
  def perfis
    Perfil.all.map {|p| [p.descricao, p.id]}
  end

  def nome(usuario)
    return if usuario.blank?

    usuario.identificacao_login.autocomplete_display
  end

  def possui_perfil?(usuario, perfil_id)
    return false if usuario.nil?

    usuario.perfis.pluck(:id).include?(perfil_id)
  end
end
