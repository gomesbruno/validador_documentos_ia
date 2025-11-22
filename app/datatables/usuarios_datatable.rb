class UsuariosDatatable < ApplicationDatatable
  private

  def map_function(dados)
    dados.map do |usuario|
      {
        nome: usuario.identificacao_login.nome,
        perfis: usuario.perfis.map { |perfil| perfil.descricao }.join(',<br>'),
        acoes: usuario.decorate.botao_deletar_usuario + usuario.decorate.botao_editar_usuario
      }
    end
  end  

  def data
    map_function(dados)
  end

  def fetch_data
    if params[:search][:value].present?
      return search(params[:search][:value])
    end
  
    Usuario.includes(:identificacao_login, :perfis)
      .paginate(page: page, per_page: per_page).order("identificacoes_login.nome #{sort_direction}")
  end  

  def search(term)
    Usuario.includes(:identificacao_login, :perfis).where("identificacoes_login.nome LIKE ?", "%#{term}%")
      .paginate(page: page, per_page: per_page).order("identificacoes_login.nome #{sort_direction}")
  end

  def sort_direction
    params[:order]['0']['dir']
  end
end