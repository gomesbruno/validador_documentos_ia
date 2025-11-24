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

  describe '.criar_novo_fiscal' do
    let(:identificacao_login) { create(:identificacao_login) }
    let!(:perfil_fiscal) { create(:perfil, tipo: 'fiscal') }
    let!(:perfil_coordenador) { create(:perfil, tipo: 'coordenador') }

    it 'não cria novo usuário quando já existe fiscal' do
      Usuario.cria_perfil(identificacao_login.id, perfil_fiscal)

      expect do
        described_class.criar_novo_fiscal(identificacao_login)
      end.not_to change(Usuario, :count)
    end

    it 'cria usuário com perfis fiscal e coordenador quando inexistente' do
      usuario = nil

      expect do
        usuario = described_class.criar_novo_fiscal(identificacao_login)
      end.to change(Usuario, :count).by(1)

      expect(usuario.perfis).to contain_exactly(perfil_fiscal, perfil_coordenador)
    end
  end

  describe '.desativar_usuario' do
    let(:usuario) { create(:usuario) }

    it 'marca data de desativação e retorna notice' do
      resposta = described_class.desativar_usuario(usuario)

      expect(resposta[:notice]).to eq('Usuário desativado com sucesso!')
      expect(usuario.reload.data_desativacao).to be_present
    end
  end

  describe '.reativar_usuario' do
    let(:usuario) { create(:usuario, data_desativacao: 1.day.ago) }

    it 'remove data de desativação e retorna notice' do
      resposta = described_class.reativar_usuario(usuario)

      expect(resposta[:notice]).to eq('Usuário reativado com sucesso!')
      expect(usuario.reload.data_desativacao).to be_nil
    end
  end
end
