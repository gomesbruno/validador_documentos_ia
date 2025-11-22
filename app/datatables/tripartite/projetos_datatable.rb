class Tripartite::ProjetosDatatable < ApplicationDatatable
  private

  def columns(tipo = nil)
    {
      id: 'tripartite_projetos.id',
      nome: 'tripartite_projetos.titulo_projeto',
      nome_orgao: 'orgaos.descricao',
      nome_unidade: 'departamentos_tripartite_projetos.descricao',
      tipo: 'tipos_projeto.descricao',
      num_processo: 'tripartite_projetos.procedimento_sei_formatado',
      cod_fec: 'tripartite_projetos.fec_codigo_projeto',
      numero_contrato: 'tripartite_projetos.numero_contrato',
      nome_coordenador: 'identificacoes_login.nome',
      nome_subcoordenador: 'subcoordenadores_tripartite_projetos.nome',
      periodo_inicio: 'tripartite_projetos.periodo_inicio',
      periodo_fim: Tripartite::ProjetoService.data_final('tripartite_projetos.id'),
      numero_fonte: 'receitas_previstas.numero_fonte_recurso',
      valor_receita: 'receitas_previstas.valor',
      nome_status: 'tripartite_status_contratacao.descricao'
    }
  end

  def search_all(tipo = nil)
    search_string = []
    columns(tipo).each do |key, colum|
      search_string << "#{colum} like :search"
    end
    search_string
  end

  def search_by_column(search_columns, tipo = nil)
    search_string = []
    hash = {}
    search_columns.each do |data|
      key = data[1][:data].to_sym
      field = columns(tipo)[key]
      term = data[1][:search][:value]
      if data[1][:search][:regex].to_boolean
        search_string << "#{field} REGEXP :#{key}"
        hash.merge!("#{key}": "#{term}")
      else
        search_string << "#{field} LIKE :#{key}"
        hash.merge!("#{key}": "%#{term}%")
      end
    end
    [search_string, hash]
  end

  # verifica quais colunas serão usadas
  def search_columns
    search = []
    params[:columns].permit!.to_h.each do |col|
      search << col if col[1][:search][:value].present?
    end
    search
  end

  def select_query(tipo = nil)
    " tripartite_projetos.id,
      tripartite_projetos.titulo_projeto as nome,
      orgaos.descricao as nome_orgao,
      departamentos_tripartite_projetos.descricao as nome_unidade,
      tipos_projeto.descricao as tipo,
      tripartite_projetos.procedimento_sei_formatado as num_processo, tripartite_projetos.fec_codigo_projeto as cod_fec,
      tripartite_projetos.numero_contrato,
      identificacoes_login.nome as nome_coordenador, subcoordenador.nome as nome_subcoordenador,
      tripartite_projetos.periodo_inicio, tripartite_projetos.periodo_fim,
      receitas_previstas.numero_fonte_recurso as numero_fonte,
      receitas_previstas.valor as valor_receita,
      tripartite_status_contratacao.descricao as nome_status
    "
  end

  def id_planos_correntes
    planos = PlanoTrabalho.where(status_apostilamento: nil).or(
      PlanoTrabalho.where(status_apostilamento_id: StatusApostilamento.finalizado_com_sucesso)
    )
                          .where(tripartite_projeto_id: Tripartite::Projeto.ativos)
    planos.group_by(&:tripartite_projeto_id).values.map do |planos|
      planos.max_by { |plano| plano.id }
    end
  end

  def fetch_data
    dados = Tripartite::Projeto
            .left_joins(:status_contratacao, [planos_trabalhos: [receitas_previstas: [:tipo_receita]]], :orgao, :departamento, :tipo_projeto, :coordenador)
            .joins('left join subcoordenadores_projetos on subcoordenadores_projetos.tripartite_projeto_id = tripartite_projetos.id and subcoordenadores_projetos.data_desativacao is  null')
            .joins("left join #{get_schema_publico}.identificacoes_login subcoordenador on subcoordenador.id = subcoordenadores_projetos.identificacao_login_id")
            .where({ planos_trabalhos: { id: id_planos_correntes } })
            .select(select_query).distinct

    if params[:search][:value].present?
      search_string = search_all
      dados = dados.where(search_string.join(' or '), search: "%#{params[:search][:value]}%")
    end
    search = search_columns
    if search.present?
      search_string, hash = search_by_column(search)

      dados = dados.where(search_string.join(' and '), hash)
    end
    dados.to_a
  end

  def map_function(dados)
    dados.uniq.map do |projeto|
      {
        id: projeto[:id],
        nome: projeto[:nome],
        nome_orgao: projeto[:nome_orgao],
        nome_unidade: projeto[:nome_unidade],
        tipo: projeto[:tipo],
        num_processo: projeto[:num_processo],
        cod_fec: projeto[:cod_fec],
        numero_contrato: projeto[:numero_contrato],
        nome_coordenador: projeto[:nome_coordenador],
        nome_subcoordenador: projeto[:nome_subcoordenador],
        periodo_inicio: projeto[:periodo_inicio].strftime('%d/%m/%y'),
        periodo_fim: Tripartite::Projeto.find(projeto[:id]).ultima_data_final.strftime('%d/%m/%y'),
        ativo: Tripartite::Projeto.find(projeto[:id]).ativo,
        numero_fonte: projeto[:numero_fonte],
        valor_receita: number_to_currency(projeto[:valor_receita]),
        nome_status: projeto[:nome_status]
      }
    end
  end
end
