class ApplicationService
  def self.transacional(mensagem_sucesso, &block)
    ActiveRecord::Base.transaction(&block)
    mensagem_sucesso
  rescue ActiveRecord::RecordInvalid => e
    { alert: e.record.errors.full_messages }
  rescue Exception => e
    { alert: e.message }
  end


  def self.autocomplete(params)
    autocomplete = Utils::PesquisaAutocomplete.new(params)
    autocomplete.pesquisar
  end
end
