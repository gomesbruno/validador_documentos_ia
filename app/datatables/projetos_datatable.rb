class ProjetosDatatable < ApplicationDatatable
  private

  def columns(tipo = nil)
    {
      id: "projetos.id",
      nome: tipo.eql?("PED") ? "projetos.titulo_projeto" : "projetos.nome_curso",
      nome_orgao: "orgaos.descricao",
      nome_unidade: "departamentos_projetos.descricao",
      tipo: tipo.eql?("PED") ? "tipos_projeto.descricao" : "tipos_curso.descricao",
      financiamento: "projetos.tipo_financiamento",
      tipo_arrecadacao: "projetos.tipo_arrecadacao",
      num_processo: "projetos.procedimento_sei_formatado",
      cod_fec: "projetos.fec_codigo_projeto",
      numero_contrato: "projetos.numero_contrato",
      numero_da_dispensa: "projetos.numero_da_dispensa",
      nome_coordenador: "identificacoes_login.nome",
      nome_subcoordenador: "subcoordenadores_projetos.nome",
      fiscal: "fiscais_projetos.nome",
      periodo_inicio: 'projetos.periodo_inicio',
      periodo_fim: ProjetoService.data_final("projetos.id"),
      ativo: ProjetoService.ativo("projetos.id"),
      data_limite: ProjetoService.data_limite("projetos.id"),
      numero_fonte: 'receitas_previstas.numero_fonte_recurso',
      tipo_receita: 'tipos_receita.descricao',
      valor_receita: tipo.eql?("PED")? "receitas_previstas.valor" : "receitas_previstas.valor_total",
      nome_status: "status.descricao",
      type: "projetos.type"
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
    " projetos.id,
      #{tipo.eql?("PED") ? "projetos.titulo_projeto" : "projetos.nome_curso"} as nome,
      orgaos.descricao as nome_orgao,
      departamentos_projetos.descricao as nome_unidade,
      #{tipo.eql?("PED") ? "tipos_projeto.descricao" : "tipos_curso.descricao"} as tipo,
      projetos.orgao_financiador as financiamento, projetos.tipo_arrecadacao,
      projetos.procedimento_sei_formatado as num_processo, projetos.fec_codigo_projeto as cod_fec,
      projetos.numero_contrato, projetos.numero_da_dispensa,
      identificacoes_login.nome as nome_coordenador, subcoordenador.nome as nome_subcoordenador,
      fiscal.nome as fiscal, projetos.periodo_inicio, projetos.periodo_fim,
      receitas_previstas.numero_fonte_recurso as numero_fonte, tipos_receita.descricao as tipo_receita,
      #{tipo.eql?("PED") ? "receitas_previstas.valor" : "receitas_previstas.valor_total"} as valor_receita,
      status.descricao as nome_status,
      projetos.type as type
    "
  end

  def id_planos_correntes
    planos = PlanoTrabalho.where(status_apostilamento: nil).or(
      PlanoTrabalho.where(status_apostilamento_id: StatusApostilamento.finalizado_com_sucesso))
                          .where(projeto_id: ProjetoPed.ativos + ProjetoCurso.ativos)
    planos.group_by(&:projeto_id).values.map do |planos|
      planos.max_by { |plano| plano.id }
    end
  end

  def fetch_data
    ped = ProjetoPed
            .left_joins(:status, [planos_trabalhos: [receitas_previstas: [:tipo_receita]]], :orgao, :departamento, :tipo_projeto, :coordenador)
            .joins('left join subcoordenadores_projetos on subcoordenadores_projetos.projeto_id = projetos.id and subcoordenadores_projetos.data_desativacao is  null')
            .joins("left join #{get_schema_publico()}.identificacoes_login subcoordenador on subcoordenador.id = subcoordenadores_projetos.identificacao_login_id")
            .joins('left join fiscais_projetos on fiscais_projetos.projeto_id = projetos.id and fiscais_projetos.data_desativacao is null and fiscais_projetos.nomeacao_concluida = 1')
            .joins("left join #{get_schema_publico()}.identificacoes_login fiscal on fiscal.id = fiscais_projetos.identificacao_login_id")
            .where({ planos_trabalhos: { id: id_planos_correntes } })
            .select(select_query("PED")).distinct

    curso = ProjetoCurso
              .left_joins(:status, [planos_trabalhos: [receitas_previstas: [:tipo_receita]]], :orgao, :departamento, :tipo_curso, :coordenador)
              .joins('left join subcoordenadores_projetos on subcoordenadores_projetos.projeto_id = projetos.id and subcoordenadores_projetos.data_desativacao is  null')
              .joins("left join #{get_schema_publico()}.identificacoes_login subcoordenador on subcoordenador.id = subcoordenadores_projetos.identificacao_login_id")
              .joins('left join fiscais_projetos on fiscais_projetos.projeto_id = projetos.id and fiscais_projetos.data_desativacao is null and fiscais_projetos.nomeacao_concluida = 1')
              .joins("left join #{get_schema_publico()}.identificacoes_login fiscal on fiscal.id = fiscais_projetos.identificacao_login_id")
              .where({ planos_trabalhos: { id: id_planos_correntes } })
              .select(select_query).distinct

    dados = ped + curso
    if params[:search][:value].present?
      search_string_ped = search_all("PED")
      search_string_curso = search_all
      dados = ped.where(search_string_ped.join(' or '), search: "%#{params[:search][:value]}%") +
        curso.where(search_string_curso.join(' or '), search: "%#{params[:search][:value]}%")
    end
    search = search_columns
    if search.present?
      search_string_ped, hash_ped = search_by_column(search, "PED")
      search_string_curso, hash_curso = search_by_column(search)

      dados = ped.where(search_string_ped.join(' and '), hash_ped) +
        curso.where(search_string_curso.join(' and '), hash_curso)
    end
    dados
  end

  def map_function(dados)
    dados.uniq.map do |projeto|
      {
        id: projeto[:id],
        nome: projeto[:nome],
        nome_orgao: projeto[:nome_orgao],
        nome_unidade: projeto[:nome_unidade],
        tipo: projeto[:tipo],
        financiamento: projeto[:financiamento],
        tipo_arrecadacao: projeto[:tipo_arrecadacao],
        num_processo: projeto[:num_processo],
        cod_fec: projeto[:cod_fec],
        numero_contrato: projeto[:numero_contrato],
        numero_da_dispensa: projeto[:numero_da_dispensa],
        nome_coordenador: projeto[:nome_coordenador],
        nome_subcoordenador: projeto[:nome_subcoordenador],
        fiscal: projeto[:fiscal],
        periodo_inicio: projeto[:periodo_inicio].strftime("%d/%m/%y"),
        periodo_fim: ProjetoService.data_final(projeto[:id]).strftime("%d/%m/%y"),
        ativo: ProjetoService.ativo(projeto[:id]),
        data_limite: ProjetoService.data_limite(projeto[:id]).strftime("%d/%m/%y"),
        numero_fonte: projeto[:numero_fonte],
        tipo_receita: projeto[:tipo_receita],
        valor_receita: number_to_currency(projeto[:valor_receita]),
        nome_status: projeto[:nome_status],
        type: projeto[:type]
      }
    end
  end
end