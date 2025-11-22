class Pub::Cidade < ActiveRecord::Base
  scope :por_estado, ->(estado_id) {
    where(estado_id: estado_id)
  }

  def autocomplete_display
    nome.to_s
  end

  #o banco de teste do publico ainda não tem essa coluna e
  # sem isso testes não conseguem nem mockar esse método
  def codigo_ibge
    self['codigo_ibge'].to_i
  end
end
