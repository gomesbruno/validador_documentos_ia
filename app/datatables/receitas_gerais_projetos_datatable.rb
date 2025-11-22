class ReceitasGeraisProjetosDatatable < ApplicationDatatable
  private

  def select_query(tipo = nil)
    " projetos.id,
      planos_trabalhos.id as plano_id,
      #{tipo.eql?("PED")? "tipos_projeto.descricao" : "tipos_curso.descricao"} as tipo,
      projetos.numero_contrato, 'Contrato' as tipo_contrato,
      #{tipo.eql?("PED")? "projetos.titulo_projeto" : "projetos.nome_curso"} as nome,
      projetos.periodo_inicio, projetos.periodo_fim,
      #{tipo.eql?("PED")? "SUM(receitas_previstas.valor)" : "SUM(receitas_previstas.valor_total)"} as valor_bruto
    "
  end

  def id_planos_correntes
    PlanoTrabalho.correntes.pluck(:id)
  end

  def fetch_data
    ped = ProjetoPed.left_joins([planos_trabalhos: [:receitas_previstas]], :tipo_projeto)
            .where({planos_trabalhos: {id: id_planos_correntes}})
            .group("projetos.id, planos_trabalhos.id")
            .includes({planos_trabalhos: [:receitas_previstas]})
            .select(select_query("PED")).distinct
    curso = ProjetoCurso.left_joins([planos_trabalhos: [:receitas_previstas]], :tipo_curso)
              .where({planos_trabalhos: {id: id_planos_correntes}})
              .group("projetos.id, planos_trabalhos.id")
              .includes({planos_trabalhos: [:receitas_previstas]})
              .select(select_query).distinct
    ped + curso
  end

  def map_function(dados)
    dados.map do |projeto|
      {
        id: projeto[:id],
        tipo: projeto[:tipo],
        numero_contrato: projeto[:numero_contrato],
        tipo_contrato: projeto[:tipo_contrato],
        nome: projeto[:nome],
        periodo_inicio: projeto[:periodo_inicio].strftime("%d/%m/%y"),
        periodo_fim: ProjetoService.data_final(projeto[:id]).strftime("%d/%m/%y"),
        ativo: ProjetoService.ativo(projeto[:id]),
        valor_bruto: number_to_currency(projeto[:valor_bruto])
      }
    end
  end

end