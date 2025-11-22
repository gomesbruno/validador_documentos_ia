class TransparenciaDatatable < ApplicationDatatable

  delegate :detalhar_transparencia_path, to: :@view

  private

  def columns(tipo = nil)
    prefix = tipo.eql?("TRIPARTITE") ? 'tripartite_projetos' : 'projetos'
    tmp = {
      nome_projeto: %w[PED TRIPARTITE].include?(tipo) ? "#{prefix}.titulo_projeto" : "projetos.nome_curso",
      numero_projeto_fec: "#{prefix}.fec_codigo_projeto",
      processo_sei: "#{prefix}.procedimento_sei_formatado",
      numero_contrato: "#{prefix}.numero_contrato",
      coordenador: "coordenador.nome",
      periodo_inicio: "#{prefix}.periodo_inicio",
      periodo_fim: "#{prefix}.periodo_fim"
    }
    tmp[:fiscal] = "fiscal.nome" unless tipo.eql?("TRIPARTITE")
    tmp
  end

  def search_all(tipo = nil)
    search_string = []
    columns(tipo).each do |key, colum|
      search_string << "#{colum} like :search"
    end
    search_string
  end

  #verifica quais colunas serão usadas
  def search_columns
    search = []
    params[:columns].permit!.to_h.each do |col|
      search << col if col[1][:search][:value].present?
    end
    search
  end

  def select_query(tipo = nil)
    prefix = tipo.eql?("TRIPARTITE") ? 'tripartite_projetos' : 'projetos'
    tmp = ""
    tmp += "#{prefix}.titulo_projeto as nome_projeto, " if %w[PED TRIPARTITE].include?(tipo)
    tmp += "#{prefix}.nome_curso as nome_projeto, " unless %w[PED TRIPARTITE].include?(tipo)
    tmp += "#{prefix}.fec_codigo_projeto as numero_projeto_fec,
            #{prefix}.numero_contrato,
            #{prefix}.procedimento_sei_formatado as processo_sei,
            coordenador.nome as coordenador"
    tmp += ", fiscal.nome as fiscal" unless tipo.eql?("TRIPARTITE")
    tmp += ", #{prefix}.id"
    tmp += ", #{prefix}.periodo_inicio, #{prefix}.periodo_fim"
    tmp
  end

  def busca ped, curso, tripartite
    if params[:search][:value].present?
      search_string_ped = search_all("PED")
      search_string_curso = search_all
      search_string_tripartite = search_all('TRIPARTITE')
      dados = ped.where(search_string_ped.join(' or '), search: "%#{params[:search][:value]}%") +
        curso.where(search_string_curso.join(' or '), search: "%#{params[:search][:value]}%") +
        tripartite.where(search_string_tripartite.join(' or '), search: "%#{params[:search][:value]}%")
    else
      dados = ped + curso + tripartite
    end
    dados
  end

  def fetch_data
    ped = ProjetoPed.left_joins(:status)
                    .joins("left join #{get_schema_publico()}.identificacoes_login coordenador on coordenador.id = projetos.coordenador_id")
                    .joins('left join fiscais_projetos on fiscais_projetos.projeto_id = projetos.id and fiscais_projetos.data_desativacao is null and fiscais_projetos.nomeacao_concluida = 1')
                    .joins("left join #{get_schema_publico()}.identificacoes_login fiscal on fiscal.id = fiscais_projetos.identificacao_login_id")
                    .where(status: { etapa: [:fase_execucao, :finalizado, :fase_prestacao_contas] })
                    .select(select_query("PED")).distinct

    curso = ProjetoCurso.left_joins(:status)
                        .joins("left join #{get_schema_publico()}.identificacoes_login coordenador on coordenador.id = projetos.coordenador_id")
                        .joins('left join fiscais_projetos on fiscais_projetos.projeto_id = projetos.id and fiscais_projetos.data_desativacao is null and fiscais_projetos.nomeacao_concluida = 1')
                        .joins("left join #{get_schema_publico()}.identificacoes_login fiscal on fiscal.id = fiscais_projetos.identificacao_login_id")
                        .where(status: { etapa: [:fase_execucao, :finalizado, :fase_prestacao_contas] })
                        .select(select_query).distinct
    tripartite = Tripartite::Projeto.left_joins(:status_contratacao)
                                    .joins("left join #{get_schema_publico()}.identificacoes_login coordenador on coordenador.id = tripartite_projetos.coordenador_id")
                                    .where(tripartite_status_contratacao_id: Tripartite::StatusContratacao.fase_execucao.last)
                                    .select(select_query("TRIPARTITE")).distinct
    busca(ped, curso, tripartite)
  end

  def map_function(dados)
    dados.map do |projeto|
        {
          nome_projeto: projeto[:nome_projeto],
          numero_projeto_fec: projeto[:numero_projeto_fec],
          numero_contrato: projeto[:numero_contrato],
          processo_sei: projeto[:processo_sei],
          coordenador: projeto[:coordenador],
          fiscal: projeto[:fiscal],
          periodo_inicio: projeto[:periodo_inicio].strftime("%m/%Y"),
          periodo_fim: projeto.ultima_data_final.strftime("%m/%Y"),
          dt_action_show: link_to('Detalhar', detalhar_transparencia_path(id: projeto.id, tipo: projeto.class.to_s))
        }
    end
  end
end
