module UsuariosHelper
  def perfis
    Perfil.all.map {|p| [p.descricao, p.id]}
  end

  def nome(usuario)
    unless usuario.blank? do
      usuario.identificacao_login.autocomplete_display
    end
    end
  end

  def possui_perfil?(usuario, perfil_id)
    usuario.perfis.pluck(:id).include?(perfil_id) ? true : false
  end
end
