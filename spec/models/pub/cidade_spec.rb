require 'rails_helper'

describe Pub::Cidade do
  subject(:cidade) { create(:cidade) }

  describe '#scopes' do
    describe '.por_estado' do
      let!(:estado) {create :estado}
      let!(:cidade_alt) {create :cidade, estado: estado}
      it 'deve retornar lista de cidades por estado' do
        expect(Pub::Cidade.por_estado(estado)).to include(cidade_alt)
      end
    end
  end
  describe '#methods' do
    describe '.autocomplete_display' do
      it 'should be equal name' do
        expect(cidade.autocomplete_display).to eq cidade.nome
      end
    end
  end
end
