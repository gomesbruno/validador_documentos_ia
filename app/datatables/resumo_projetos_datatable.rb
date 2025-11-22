class ResumoProjetosDatatable < ProjetosDatatable
  private

  def columns(tipo = nil)
    {
      id: "projetos.id",
      nome: tipo.eql?("PED") ? "projetos.titulo_projeto" : "projetos.nome_curso",
      nome_orgao: "unidades_projetos.descricao",
      nome_unidade: "departamentos_projetos.descricao",
      tipo: tipo.eql?("PED") ? "tipos_projeto.descricao" : "tipos_curso.descricao",
      financiamento: "projetos.tipo_financiamento",
      tipo_arrecadacao: "projetos.tipo_arrecadacao",
      num_processo: "projetos.procedimento_sei_formatado",
      cod_fec: "projetos.fec_codigo_projeto",
      numero_contrato: "projetos.numero_contrato",
      numero_da_dispensa: "projetos.numero_da_dispensa",
      nome_coordenador: "identificacoes_login.nome",
      nome_subcoordenador: "subcoordenador.nome",
      fiscal: "fiscal.nome",
      periodo_inicio: 'projetos.periodo_inicio',
      periodo_fim: ProjetoService.data_final("projetos.id"),
      somatorio_receitas: tipo.eql?("PED") ? "SUM(receitas_previstas.valor)" : "SUM(receitas_previstas.valor_total)",
      nome_status: "status.descricao",
      nome_status_prestacao: "status_prestacao.descricao",
      data_recebimento_pc: "recebimento_pc.created_at",
      data_primeira_analise_pc: "primeira_analise_pc.created_at",
      data_primeiro_termino_pc: "primeiro_termino_pc.created_at",
      analista_plap: "analista_plap.nome",
      type: "projetos.type"
    }
  end

  def select_query(tipo = nil)
    " projetos.id,
      #{tipo.eql?("PED") ? "projetos.titulo_projeto" : "projetos.nome_curso"} as nome,
      unidades_projetos.descricao as nome_orgao,
      departamentos_projetos.descricao as nome_unidade,
      #{tipo.eql?("PED") ? "tipos_projeto.descricao" : "tipos_curso.descricao"} as tipo,
      projetos.orgao_financiador as financiamento, projetos.tipo_arrecadacao,
      projetos.procedimento_sei_formatado as num_processo, projetos.fec_codigo_projeto as cod_fec,
      projetos.numero_contrato, projetos.numero_da_dispensa,
      identificacoes_login.nome as nome_coordenador, subcoordenador.nome as nome_subcoordenador,
      fiscal.nome as fiscal,
      projetos.periodo_inicio, projetos.periodo_fim,
      #{tipo.eql?("PED") ? "SUM(receitas_previstas.valor)" : "SUM(receitas_previstas.valor_total)"} as somatorio_receitas,
      status.descricao as nome_status,
      status_prestacao.descricao as nome_status_prestacao,
      recebimento_pc.created_at as data_recebimento_pc,
      primeira_analise_pc.created_at as data_primeira_analise_pc,
      primeiro_termino_pc.created_at as data_primeiro_termino_pc,
      analista_plap.nome as analista_plap,
      envio_regularizacao_1.created_at as data_envio_regularizacao_pc_1,
      recebimento_regularizacao_1.created_at as data_recebimento_regularizacao_1,
      envio_regularizacao_2.created_at as data_envio_regularizacao_pc_2,
      recebimento_regularizacao_2.created_at as data_recebimento_regularizacao_2,
      envio_regularizacao_3.created_at as data_envio_regularizacao_pc_3,
      recebimento_regularizacao_3.created_at as data_recebimento_regularizacao_3,
      envio_regularizacao_4.created_at as data_envio_regularizacao_pc_4,
      recebimento_regularizacao_4.created_at as data_recebimento_regularizacao_4,
      envio_regularizacao_5.created_at as data_envio_regularizacao_pc_5,
      recebimento_regularizacao_5.created_at as data_recebimento_regularizacao_5,
      envio_regularizacao_6.created_at as data_envio_regularizacao_pc_6,
      recebimento_regularizacao_6.created_at as data_recebimento_regularizacao_6,
      envio_regularizacao_7.created_at as data_envio_regularizacao_pc_7,
      recebimento_regularizacao_7.created_at as data_recebimento_regularizacao_7,
      envio_regularizacao_8.created_at as data_envio_regularizacao_pc_8,
      recebimento_regularizacao_8.created_at as data_recebimento_regularizacao_8,
      envio_regularizacao_9.created_at as data_envio_regularizacao_pc_9,
      recebimento_regularizacao_9.created_at as data_recebimento_regularizacao_9,
      envio_regularizacao_10.created_at as data_envio_regularizacao_pc_10,
      recebimento_regularizacao_10.created_at as data_recebimento_regularizacao_10,
      aprovacao_pc.created_at as data_aprovacao_pc,
      projetos.type as type
    "
  end

  def fetch_data
    ped = ProjetoPed.includes(planos_trabalhos: [:receitas_previstas])
                    .joins("LEFT OUTER JOIN `tipos_projeto` ON
                          `tipos_projeto`.`id` = `projetos`.`tipo_projeto_id`")
                    .joins_relatorio_resumo
                    .where({ planos_trabalhos: { id: id_planos_correntes } })
                    .group("projetos.id, planos_trabalhos.id, fiscais_projetos.id, subcoordenadores_projetos.id")
                    .select(select_query('PED')).distinct

    curso = ProjetoCurso.includes(planos_trabalhos: [:receitas_previstas])
                        .joins("LEFT OUTER JOIN `tipos_curso` ON
                              `tipos_curso`.`id` = `projetos`.`tipo_curso_id`")
                        .joins_relatorio_resumo
                        .group("projetos.id, planos_trabalhos.id, fiscais_projetos.id, subcoordenadores_projetos.id")
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
    dados.map do |projeto|
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
        somatorio_receitas: number_to_currency(projeto[:somatorio_receitas]),
        nome_status: projeto[:nome_status],
        data_recebimento_pc: projeto[:data_recebimento_pc]&.strftime("%d/%m/%y"),
        data_inicio_analise_pc: projeto[:data_primeira_analise_pc]&.strftime("%d/%m/%y"),
        data_termino_analise_pc: projeto[:data_primeiro_termino_pc]&.strftime("%d/%m/%y"),
        analista_pc: projeto[:analista_plap],
        status_pc: projeto[:nome_status_prestacao],
        data_envio_regularizacao_pc_1: projeto[:data_envio_regularizacao_pc_1]&.strftime("%d/%m/%y"),
        data_recebimento_regularizacao_pc_1: projeto[:data_recebimento_regularizacao_1]&.strftime("%d/%m/%y"),
        data_envio_regularizacao_pc_2: projeto[:data_envio_regularizacao_pc_2]&.strftime("%d/%m/%y"),
        data_recebimento_regularizacao_pc_2: projeto[:data_recebimento_regularizacao_2]&.strftime("%d/%m/%y"),
        data_envio_regularizacao_pc_3: projeto[:data_envio_regularizacao_pc_3]&.strftime("%d/%m/%y"),
        data_recebimento_regularizacao_pc_3: projeto[:data_recebimento_regularizacao_3]&.strftime("%d/%m/%y"),
        data_envio_regularizacao_pc_4: projeto[:data_envio_regularizacao_pc_4]&.strftime("%d/%m/%y"),
        data_recebimento_regularizacao_pc_4: projeto[:data_recebimento_regularizacao_4]&.strftime("%d/%m/%y"),
        data_envio_regularizacao_pc_5: projeto[:data_envio_regularizacao_pc_5]&.strftime("%d/%m/%y"),
        data_recebimento_regularizacao_pc_5: projeto[:data_recebimento_regularizacao_5]&.strftime("%d/%m/%y"),
        data_envio_regularizacao_pc_6: projeto[:data_envio_regularizacao_pc_6]&.strftime("%d/%m/%y"),
        data_recebimento_regularizacao_pc_6: projeto[:data_recebimento_regularizacao_6]&.strftime("%d/%m/%y"),
        data_envio_regularizacao_pc_7: projeto[:data_envio_regularizacao_pc_7]&.strftime("%d/%m/%y"),
        data_recebimento_regularizacao_pc_7: projeto[:data_recebimento_regularizacao_7]&.strftime("%d/%m/%y"),
        data_envio_regularizacao_pc_8: projeto[:data_envio_regularizacao_pc_8]&.strftime("%d/%m/%y"),
        data_recebimento_regularizacao_pc_8: projeto[:data_recebimento_regularizacao_8]&.strftime("%d/%m/%y"),
        data_envio_regularizacao_pc_9: projeto[:data_envio_regularizacao_pc_9]&.strftime("%d/%m/%y"),
        data_recebimento_regularizacao_pc_9: projeto[:data_recebimento_regularizacao_9]&.strftime("%d/%m/%y"),
        data_envio_regularizacao_pc_10: projeto[:data_envio_regularizacao_pc_10]&.strftime("%d/%m/%y"),
        data_recebimento_regularizacao_pc_10: projeto[:data_recebimento_regularizacao_10]&.strftime("%d/%m/%y"),
        data_aprovacao_pc: projeto[:data_aprovacao_pc]&.strftime("%d/%m/%y"),
        type: projeto[:type]
      }
    end
  end

end