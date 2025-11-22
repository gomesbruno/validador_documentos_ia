class DespesasDosProjetosDatatable < ApplicationDatatable
  private

  def select_query(tipo = nil)
    " projetos.numero_contrato, 'Contrato' as tipo_contrato,
      projetos.id,planos_trabalhos.id as plano_id,
      #{tipo.eql?("PED")? "SUM(receitas_previstas.valor)" : "SUM(receitas_previstas.valor_total)"} as financeiro,
      '-' as material_tipo, '-' as material_valor,
      COUNT(bolsistas.id) as quantidade,
      SUM(bolsistas.valor) as valor_bolsas,
      SUM(itens_natureza_despesa.valor_a_definir) as valor_a_definir
    "
  end

  def id_planos_correntes
    PlanoTrabalho.correntes.pluck(:id)
  end

  def fetch_data
    ped = ProjetoPed.left_joins( [planos_trabalhos: [:itens_natureza_despesa, :bolsistas_ted, :receitas_previstas ] ] )
            .where({itens_natureza_despesa: {tipo_natureza_despesa_id: 3}})
            .where({planos_trabalhos: {id: id_planos_correntes}})
            .group("projetos.id, planos_trabalhos.id")
            .select(select_query("PED"))

    curso = ProjetoCurso.left_joins( [planos_trabalhos: [:itens_natureza_despesa, :bolsistas_ted, :receitas_previstas ] ] )
            .where({itens_natureza_despesa: {tipo_natureza_despesa_id: 3}})
            .where({planos_trabalhos: {id: id_planos_correntes}})
            .group("projetos.id, planos_trabalhos.id")
            .select(select_query)
    ped + curso
  end

  def map_function(dados)
    dados.map do |projeto|
      {
        numero_contrato: projeto[:numero_contrato],
        tipo_contrato: projeto[:tipo_contrato],
        ativo: ProjetoService.ativo(projeto[:id]),
        financeiro: number_to_currency(projeto[:financeiro]),
        material_tipo: projeto[:material_tipo],
        material_valor: projeto[:material_valor],
        quantidade: projeto[:quantidade],
        valor_bolsas: number_to_currency(projeto[:valor_bolsas] || 0),
        valor_a_definir: number_to_currency(projeto[:valor_a_definir].to_f),
        valor_total: number_to_currency(
          (projeto[:valor_bolsas] || 0) + (projeto[:valor_a_definir] || 0)
        )
      }
    end
  end

end
