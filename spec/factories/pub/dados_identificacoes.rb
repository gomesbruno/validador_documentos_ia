FactoryBot.define do
  factory :dados_identificacao, class: 'Pub::DadosIdentificacao' do
    nome_abreviado { 'Fulano da Silva' }
    iduff_mail { 'fulano' }
    cidade
    endereco_rua { 'Rua A' }
    endereco_numero { '200' }
    endereco_bairro { 'Centro' }
    endereco_cep { '12224751' }
    ddd_telefone { '21' }
    telefone { '1111-2222' }
    ddd_celular { '21' }
    celular { '1111-2222' }
    email { 'exemplo@mail.com' }
    identidade { '111111' }
    identidade_orgao { 'detran' }
    sequence(:cpf, &:to_s)

    association :identidade_estado, factory: :estado
    association :naturalidade_estado, factory: :estado
    association :pais_nacionalidade, factory: :pais
    association :nacionalidade, factory: :pais

    to_create do |instance|
      instance.id = Pub::DadosIdentificacao.where(cpf: instance.cpf).first_or_create(instance.attributes).id
      instance.reload
    end
  end
end
