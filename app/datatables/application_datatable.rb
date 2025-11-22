class ApplicationDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        recordsTotal: dados.count,
        recordsFiltered: dados.count,
        data: data
    }
  end


  private

  #caso não vá utilizar o sort, sobreescreva e retorne apenas:     map_function(dados)
  def data
    result = ordenar(dados)
    filtered_data(result)
  end

  def ordenar(array_dados)
    sort_direction.eql?("asc")?
      map_function(array_dados).sort_by!{ |d| [d[:"#{sort_column}"] ? 0 : 1, d[:"#{sort_column}"]] } :
      map_function(array_dados).sort_by!{ |d| [d[:"#{sort_column}"] ? 0 : 1, d[:"#{sort_column}"]] }.reverse!
  end

  def dados
    @dados ||= fetch_data
  end

  # no caso dos dados serem uma unica tabela do active record,
  # use .paginate(page: page, per_page: per_page) dentro do fetch_data e retorne apenas
  # @dados aqui para aplicar o LIMIT e OFFSET direto no BD
  def filtered_data(dados_para_paginar)
    @page_results = WillPaginate::Collection.create(page, per_page, dados_para_paginar.count) do |pager|
      start = (page-1)*per_page # assuming current_page is 1 based.
      pager.replace(dados_para_paginar[start, per_page])
    end
  end

  #somente se for usar filtros de consulta, ver projetos_datatable.rb
  # Mapeamento para buscar usando os filtros no banco via sql
  # as chaves devem ser unicas para evitar loop e confundir com outros atributos do modelo
  def columns
    raise "Deve ser implementado"
  end

  #lembre de nomear os campos para poder seleciona-los facilmente no método map_function
  def select_query
    raise "deve ser implementado"
  end

  def fetch_data
    raise "Deve ser implementado"
  end

  # mapeamento em como os dados serão exibidos
  # os atributos do objeto devem ser unicos para evitar loop e confundir com outros atributos do modelo
  # o que for colocado como 'as XYZ' na query do select virará um atributo
  def map_function(dados)
    raise "Deve ser implementado"
  end

  def page
    params[:start].to_i / per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : dados.count
  end

  def sort_column
    column = params[:order]['0'][:column]
    params[:columns][column][:data] #KEY
  end

  def sort_direction
    params[:order]['0'][:dir] == "desc" ? "desc" : "asc"
  end

  def get_schema_publico
    if Rails.env.development?
      'publico_development'
    elsif Rails.env.homologacao?
      'PUBLICO_HOMOLOG'
    elsif Rails.env.test?
      'publico_test'
    else
      'PUBLICO_PROD'
    end
  end
end