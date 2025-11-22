class FiscalizacaoDatatable < ApplicationDatatable
  private
  
  def count
    data.count
  end
  
  def total_entries
    data.count
  end
  
  def map_function(dados)
    dados.map do |fiscalizacao|
      {
        titulo_projeto: fiscalizacao.titulo_projeto,
        status_projeto: fiscalizacao.status_projeto,
        contrato: fiscalizacao.numero_contrato,
        fec_codigo_projeto: fiscalizacao.fec_codigo_projeto,
        procedimento_sei_formatado: fiscalizacao.procedimento_sei_formatado,
        data_criacao: fiscalizacao.data_criacao,
        data_limite_conclusao: fiscalizacao.data_limite_conclusao,
        status: fiscalizacao.status_fiscalizacao.descricao,
        acoes: fiscalizacao.botoes_de_acoes
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

    Fiscalizacao.where.not(status_fiscalizacao: StatusFiscalizacao.finalizado).decorate
  end
  
  def search(term)
    joins = <<-SQL
      INNER JOIN projetos ON fiscalizacoes.projeto_id = projetos.id
      INNER JOIN status ON projetos.status_id = status.id
      INNER JOIN status_fiscalizacao ON fiscalizacoes.status_fiscalizacao_id = status_fiscalizacao.id
    SQL
  
    where = <<-SQL
      projetos.nome_curso LIKE ? OR
      projetos.titulo_projeto LIKE ? OR
      projetos.numero_contrato LIKE ? OR
      projetos.fec_codigo_projeto LIKE ? OR
      projetos.procedimento_sei_formatado LIKE ? OR
      status.descricao LIKE ? OR
      DATE_FORMAT(fiscalizacoes.created_at, '%d/%m/%Y') LIKE ? OR
      DATE_FORMAT(DATE_ADD(fiscalizacoes.inicio_prazo_bloqueio, INTERVAL #{Configuracao.dias_conclusao_fiscalizacao_automatica - 1} DAY), '%d/%m/%Y') LIKE ? OR
      status_fiscalizacao.descricao LIKE ?
    SQL
  
    parametros = Array.new(9, "%#{term}%")
  
    Fiscalizacao
      .joins(joins)
      .where.not(status_fiscalizacao: StatusFiscalizacao.finalizado)
      .where(where, *parametros)
      .decorate
  end  
end