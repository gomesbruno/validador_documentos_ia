require 'rails_helper'

describe Pub::Vinculacao do
  let(:vinculacao) { Pub::Vinculacao.new }
  subject { vinculacao }

  describe '#associações' do
    it { is_expected.to have_one(:funcionario) }
  end

  describe 'scope' do
    let(:desativada) { create :vinculacao, :discente, ativo: "\x00" }
    let(:ativa) { create :vinculacao, :discente, ativo: "\x01" }

    context '.ativa' do
      it { expect(described_class.ativa).to include(ativa) }
      it { expect(described_class.ativa).not_to include(desativada) }
    end
  end

  describe '#métodos' do
    let!(:vinculacao_discente) { create :vinculacao, :discente }
    let!(:vinculacao_ted) { create :vinculacao, :ted }

    describe '#autocomplete_display_bolsista_discente' do
      it 'deve exibir nome e matricula do bolsista' do
        expect(vinculacao_discente.autocomplete_display_bolsista_discente)
            .to eq("#{vinculacao_discente.nome} - #{vinculacao_discente.matricula}")
      end
    end

    describe '#autocomplete_display_bolsista_ted' do
      it 'deve exibir nome e matricula do bolsista' do
        expect(vinculacao_ted.autocomplete_display_bolsista_ted)
            .to eq("#{vinculacao_ted.nome} - #{vinculacao_ted.matricula}")
      end
    end

    describe '.bolsista_discente' do
      it 'deve retornar o bolsista discente de acordo com o termo passado como paramêtro' do
        expect(Pub::Vinculacao.bolsista_discente(vinculacao_discente.nome))
            .to include(vinculacao_discente)
      end
    end

    describe '.bolsista_ted' do
      it 'deve retornar o bolsista servidor de acordo com o termo passado como paramêtro' do
        expect(Pub::Vinculacao.bolsista_ted(vinculacao_ted.nome))
            .to include(vinculacao_ted)
      end
    end

    describe '.tecnico?' do
      let(:tecnico) { create :vinculacao, :tecnico }

      context 'quando tecnico' do
        it 'deve retornar verdadeiro' do
          expect(tecnico.tecnico?).to match(true)
        end
      end
    end
  end
end
