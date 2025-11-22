class Tripartite::AtividadesPlapDatatable < ApplicationDatatable
  attr_accessor :data_inicial, :data_final
  def as_json(options = {})
    {
      recordsTotal: dados.count,
      recordsFiltered: dados.count,
      data: data,
      data_inicial: @data_inicial.strftime("%d/%m/%Y"),
      data_final: @data_final.strftime("%d/%m/%Y"),
    }
  end

  private

  def data
    result = sort_column.eql?("data") ? ordenar_por_data(dados) : ordenar(dados)
    filtered_data(result)
  end

  def data_inicio
    params[:data_inicio].presence&.to_datetime || Tripartite::AcompanhamentoStatusContratacao.first.created_at.to_datetime
  end

  def data_fim
    params[:data_fim].presence&.to_datetime || DateTime.now
  end

  def fetch_data
    @data_inicial = data_inicio
    @data_final = data_fim
    hash_dados = monta_dados(data_inicial,data_final)
    todas_datas = todas_datas(data_inicial,data_final)
    data_agrupada =  hash_dados.values.flatten!&.group_by(&:data)
    data_transformada = transforma_datas(data_agrupada)
    ( data_transformada.values + todas_datas ).uniq { |h| h[:data] }
  end

  def map_function(dados)
    dados.map do |acompanhamentos|
      {
        data: acompanhamentos[:data],
        projetos_analisados: acompanhamentos[:tripartite_acompanhamentos_status_contratacoes],
        apostilamentos_realizados: acompanhamentos[:acompanhamentos_status_apostilamentos],
        termos_aditivos_realizados: acompanhamentos[:tripartite_acompanhamentos_status_termos_aditivos]
      }
    end
  end

  def ordenar_por_data(array_dados)
    sort_direction.eql?("asc")?
      map_function(array_dados).sort_by!{ |d| [d[:"#{sort_column}"].to_date ? 0 : 1, d[:"#{sort_column}"].to_date] } :
      map_function(array_dados).sort_by!{ |d| [d[:"#{sort_column}"].to_date ? 0 : 1, d[:"#{sort_column}"].to_date] }.reverse!
  end

  def todas_datas(data_inicial,data_final)
    monts_years_between(data_inicial.to_date, data_final.to_date).map do |mes_ano|
      {data: mes_ano.strftime("%m/%Y"),
       tripartite_acompanhamentos_status_contratacoes: 0,
       acompanhamentos_status_apostilamentos: 0,
       tripartite_acompanhamentos_status_termos_aditivos: 0,
       }
    end
  end

  def transforma_datas(datas_agrupadas)
    data_transformada = datas_agrupadas.transform_values{|value| value.map{|m| Hash[m.class.table_name.to_sym, m.quantidade ]}.reduce({}, :merge) }
    data_transformada.each do |key,value|
      data_transformada[key][:data] ||= key
      data_transformada[key][:tripartite_acompanhamentos_status_contratacoes] ||= 0
      data_transformada[key][:acompanhamentos_status_apostilamentos] ||= 0
      data_transformada[key][:tripartite_acompanhamentos_status_termos_aditivos] ||= 0
    end
  end

  def monta_dados(data_inicial, data_final)
    projetos = projetos_analisado(data_inicial, data_final)
    termos = termos_aditivos_realizados(data_inicial, data_final)
    apostilamentos = apostilamentos_realizados(data_inicial, data_final)
    { projetos_analisados: projetos, apostilamentos_realizados: apostilamentos,
          termos_aditivos_realizados: termos
    }
  end

  def projetos_analisado(data_inicial, data_final)
    Tripartite::AcompanhamentoStatusContratacao.
      por_etapa(:aguardando_parecer_da_procuradoria_uff).
      entre_datas_criacao(data_inicial,data_final).
      select("count(tripartite_acompanhamentos_status_contratacoes.id) as quantidade, DATE_FORMAT(tripartite_acompanhamentos_status_contratacoes.created_at,'%m/%Y') as data").
      group("data")
  end

  def apostilamentos_realizados(data_inicial, data_final)
    AcompanhamentoStatusApostilamento.
      tripartite.
      por_etapa(:finalizado_com_sucesso).
      entre_datas_criacao(data_inicial,data_final).
      select("count(acompanhamentos_status_apostilamentos.id) as quantidade, DATE_FORMAT(acompanhamentos_status_apostilamentos.created_at,'%m/%Y') as data").
      group("data")
  end

  def termos_aditivos_realizados(data_inicial, data_final)
    Tripartite::AcompanhamentoStatusTermoAditivo.
      por_etapa(:finalizado).
      entre_datas_criacao(data_inicial,data_final).
      select("count(tripartite_acompanhamentos_status_termos_aditivos.id) as quantidade, DATE_FORMAT(tripartite_acompanhamentos_status_termos_aditivos.created_at,'%m/%Y') as data").
      group("data")
  end

  def monts_years_between(first, last)
    first = first << 1
    (12*last.year + last.month - 12*first.year - first.month).times.map do
      first.strftime("%b %Y")
      first = first >> 1
    end
  end
end
