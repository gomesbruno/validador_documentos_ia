require 'rails_helper'

RSpec.describe UsuarioService do
  describe '.criar_novo_coordenador' do
    let(:identificacao_login) { create(:identificacao_login, iduff: '123') }
    let!(:perfil_coordenador) { create(:perfil, tipo: 'coordenador') }

    it 'cria usuario com perfil de coordenador quando não existe' do
      usuario = described_class.criar_novo_coordenador(identificacao_login)

      expect(usuario.perfis).to include(perfil_coordenador)
    end

    it 'reaproveita usuario existente com perfil coordenador' do
      usuario_existente = Usuario.cria_perfil(identificacao_login.id, perfil_coordenador)

      expect(described_class.criar_novo_coordenador(identificacao_login)).to eq(usuario_existente)
    end
  end

  describe '.modifica_perfil' do
    let(:perfil_assistente) { create(:perfil, tipo: 'assistente') }
    let(:perfil_fiscal) { create(:perfil, tipo: 'fiscal') }
    let(:usuario) { create(:usuario) }

    before do
      Usuario.cria_perfil(usuario.identificacao_login.id, perfil_assistente)
      Usuario.cria_perfil(usuario.identificacao_login.id, perfil_fiscal)
    end

    it 'remove perfis não selecionados e adiciona os novos' do
      response = described_class.modifica_perfil(usuario, [perfil_assistente.id])

      expect(response[:notice]).to eq('Usuário modificado com sucesso!')
      expect(usuario.reload.perfis).to contain_exactly(perfil_assistente)
    end
  end
end
