require 'rails_helper'

RSpec.describe UsuariosController, type: :controller do
  let(:identificacao_login) { create(:identificacao_login) }

  describe 'GET #index' do
    it 'retorna sucesso' do
      get :index

      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'redireciona com notice retornado pelo serviço' do
      expect(UsuarioService).to receive(:criar_usuario)
        .with(identificacao_login.id.to_s, ['1'])
        .and_return({ notice: 'Usuário criado com sucesso!' })

      post :create, params: { usuario: { identificacao_login_id: identificacao_login.id, opcoes_perfil: ['1'] } }

      expect(response).to redirect_to(usuarios_path)
      expect(flash[:notice]).to eq('Usuário criado com sucesso!')
    end
  end

  describe 'PATCH #update' do
    let(:usuario) { create(:usuario, identificacao_login: identificacao_login) }

    it 'redireciona após atualizar perfis' do
      expect(UsuarioService).to receive(:modifica_perfil)
        .with(usuario, ['2'])
        .and_return({ notice: 'Usuário modificado com sucesso!' })

      patch :update, params: { id: usuario.id, usuario: { opcoes_perfil: ['2'] } }

      expect(response).to redirect_to(usuarios_path)
      expect(flash[:notice]).to eq('Usuário modificado com sucesso!')
    end
  end

  describe 'DELETE #destroy' do
    let!(:usuario) { create(:usuario, identificacao_login: identificacao_login) }

    it 'desativa o usuario e redireciona' do
      delete :destroy, params: { id: usuario.id }

      expect(response).to redirect_to(usuarios_url)
      expect(flash[:notice]).to eq('Usuário desativado com sucesso!')
      expect(usuario.reload.data_desativacao).to be_present
    end
  end

  describe 'PATCH #reativar' do
    let!(:usuario) { create(:usuario, identificacao_login: identificacao_login, data_desativacao: Time.zone.now) }

    it 'reativa o usuario e redireciona' do
      patch :reativar, params: { id: usuario.id }

      expect(response).to redirect_to(usuarios_url)
      expect(flash[:notice]).to eq('Usuário reativado com sucesso!')
      expect(usuario.reload.data_desativacao).to be_nil
    end
  end
end
