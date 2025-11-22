class ControleTetoBolsasDatatable
  delegate :params, :h, :link_to, :number_to_currency, :diff, :detalhar_controle_teto_bolsas_index_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(_options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: ControleTetoBolsas.count,
      iTotalDisplayRecords: controle_teto_bolsas.total_entries,
      aaData: data
    }
  end

  private

  def data
    controle_teto_bolsas.map do |controle_teto_bolsa|
      [
        controle_teto_bolsa.nome,
        controle_teto_bolsa.matricula,
        controle_teto_bolsa.decorate.descricao_vinculo,
        controle_teto_bolsa.decorate.referencia_formatada,
        number_to_currency(controle_teto_bolsa.valor_total_bolsas),
        number_to_currency(controle_teto_bolsa.valor_salario),
        number_to_currency(controle_teto_bolsa.total),
        controle_teto_bolsa.observacao.present? ? '<div style="text-align: center"><i class="fa fa-warning" style="color:red"></i></div>' : '',
        link_to('Detalhar', detalhar_controle_teto_bolsas_index_path(matricula: controle_teto_bolsa.matricula, referencia: controle_teto_bolsa.referencia)),
        cor_registro(controle_teto_bolsa)
      ]
    end
  end

  def cor_registro(controle_teto_bolsa)
    return "#fff3cd" if controle_teto_bolsa.decorate.salario_estimado?
    return "#f8d7da" if controle_teto_bolsa.decorate.maior_ou_igual_ao_teto?
    return ""
  end

  def controle_teto_bolsas
    @controle_teto_bolsas ||= fetch_controle_teto_bolsas
  end

  def fetch_controle_teto_bolsas
    controle_teto_bolsas = ControleTetoBolsas.joins(:vinculacao).joins(vinculacao: :identificacao_login).joins(vinculacao: :vinculo).order("#{sort_column} #{sort_direction}")
    controle_teto_bolsas = controle_teto_bolsas.page(page).per_page(per_page)
    if params[:sSearch]
      texto_pesquisa = []
      %w(identificacoes_login.nome vinculacoes.matricula vinculos.descricao referencia valor_total_bolsas valor_salario total).each do |term|
        texto_pesquisa << "#{term} like :search"
      end

      texto_pesquisa << "date_format(referencia, '%m.%Y') like :search"

      controle_teto_bolsas = controle_teto_bolsas.where(texto_pesquisa.join(' or '),
                                search: ActiveRecord::Base::sanitize_sql("%#{params[:sSearch]}%"))
    end

    controle_teto_bolsas
  end

  def page
    params[:iDisplayStart].to_i / per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[identificacoes_login.nome vinculacoes.matricula vinculos.descricao referencia valor_total_bolsas valor_salario total]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == 'desc' ? 'desc' : 'asc'
  end
end
