require 'rails_helper'

describe Pub::DadosIdentificacao, type: :model do
  let(:outro_email) { 'outro_email@exemplo.com' }
  let(:iduff_mail) { 'anonimo' }
  let(:dados_identificacao) do
    create(:dados_identificacao, iduff_mail: iduff_mail, email: outro_email)
  end

  describe 'métodos' do
    describe '.telefones' do
      let(:telefones) do
        "(#{dados_identificacao.ddd_telefone}) "\
        "#{dados_identificacao.telefone} / "\
        "(#{dados_identificacao.ddd_celular}) "\
        "#{dados_identificacao.celular}"
      end

      it 'retorna telefone e celular formatado' do
        expect(dados_identificacao.telefones).to eq telefones
      end
    end

    describe '.email' do
      context 'quando existe iduff_mail' do
        it 'retorna iduff_mail concatenado com o dominio @id.uff.br' do
          expect(dados_identificacao.email).to eq "#{iduff_mail}@id.uff.br"
        end
      end

      context 'quando não existe iduff_mail' do
        before do
          dados_identificacao.update(iduff_mail: nil)
        end

        it 'retorna o outro email cadastrado' do
          expect(dados_identificacao.email).to eq outro_email
        end
      end
    end
  end
end
