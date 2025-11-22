class BlacklistDatatable < ApplicationDatatable
  include BlacklistBolsistasHelper
  private

  def count
    data.count
  end

  def total_entries
    data.count
  end

  def map_function(dados)
    dados.map do |bolsista|
      {
          nome: bolsista.vinculacao.nome,
          matricula: bolsista.vinculacao.matricula,
          projetos: bolsista.projetos.join(', '),
          acoes: deletar(bolsista, @view)
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
    BlacklistBolsista.all
  end

  def search(term)
    BlacklistBolsista.joins([vinculacao: [:identificacao_login]]).where("nome LIKE '%#{term}%'")
  end
end