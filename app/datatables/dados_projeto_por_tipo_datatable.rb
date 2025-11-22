class DadosProjetoPorTipoDatatable
  delegate :params, :h, :link_to, :number_to_currency, :diff, to: :@view

  def initialize(view, relation, tipo)
    @view = view
    @relation = relation
    @tipo = tipo
  end

  def as_json(_options = {})
    {
      sEcho: params[:sEcho].to_i,
        iTotalRecords: data.count,
        iTotalDisplayRecords: data.count,
        aaData: data
    }
  end

  private

  def data
    map_function dados
  end

  def dados
    @dados ||= fetch_data
  end

  def fetch_data
    dados = @relation.order("#{sort_column} #{sort_direction}")
    if params[:sSearch].present?
      dados = @relation.send("pesquisar_por_#{@tipo}", params[:sSearch])
      return dados.group_by(&@tipo.to_sym)
    else
      return dados.send("agrupados_por_#{@tipo}")
    end
  end

  def sort_column
    columns = %w[created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == 'desc' ? 'desc' : 'asc'
  end

  private

  def map_function(dados)
    if %w[ProjetoPed ProjetoCurso].include? @relation.to_s
      dados.map do |tipo, items|
        [
          tipo.descricao,
          items.count
        ]
      end
    else
      dados.map do |fonte, receitas|
        [fonte, receitas.map(&:plano_trabalho).map(&:projeto).flatten.count]
      end
    end
  end
end
