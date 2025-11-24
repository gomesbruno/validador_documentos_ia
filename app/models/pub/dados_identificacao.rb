class Pub::DadosIdentificacao < ActiveRecord::Base
  self.table_name = 'dados_identificacoes'

  belongs_to :identificacao_login, class_name: 'Pub::IdentificacaoLogin', optional: true
  belongs_to :nacionalidade, foreign_key: 'nacionalidade_id', class_name: 'Pub::Pais'
  belongs_to :cidade, foreign_key: 'endereco_cidade_id', class_name: 'Pub::Cidade'

  def telefones
    "(#{ddd_telefone}) #{telefone} / (#{ddd_celular}) #{celular}"
  end

  def email
    iduff_mail ? "#{iduff_mail}@id.uff.br" : super
  end

  def brasileiro?
    nacionalidade.sigla == "BR"
  end
end
