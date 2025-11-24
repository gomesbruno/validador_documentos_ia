class UsuariosDatatable < ApplicationDatatable
  def as_json(_options = {})
    {
      recordsTotal: base_scope.count,
      recordsFiltered: filtered_scope.count,
      data: data
    }
  end

  private

  def map_function(dados)
    dados.map do |usuario|
      {
        nome: usuario.identificacao_login.nome,
        cpf: usuario.identificacao_login.dados_identificacao&.cpf,
        perfis: usuario.perfis.map(&:descricao).join(', '),
        status: usuario.ativo? ? 'Ativo' : 'Desativado',
        acoes: @view.render(partial: 'usuarios/actions', locals: { usuario: usuario })
      }
    end
  end

  def data
    map_function(dados)
  end

  def fetch_data
    filtered_scope
      .includes(:perfis, identificacao_login: :dados_identificacao)
      .order("identificacoes_login.nome #{sort_direction}")
      .paginate(page: page, per_page: per_page)
  end

  def search(term)
    base_scope
      .where("identificacoes_login.nome LIKE :term OR identificacoes_login.iduff LIKE :term OR dados_identificacoes.cpf LIKE :term", term: "%#{term}%")
  end

  def sort_direction
    params[:order]['0']['dir']
  end

  def search_value
    params.dig(:search, :value)
  end

  def base_scope
    Usuario.left_joins(identificacao_login: :dados_identificacao)
  end

  def filtered_scope
    return base_scope if search_value.blank?

    search(search_value)
  end
end
