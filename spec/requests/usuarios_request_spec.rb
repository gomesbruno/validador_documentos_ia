require 'rails_helper'

RSpec.describe 'Usuarios', type: :request do
  describe 'GET /usuarios' do
    it 'retorna sucesso' do
      get usuarios_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /usuarios/autocomplete_usuario_identificacao_login' do
    it 'retorna resultados formatados' do
      identificacao_login = create(:identificacao_login, nome: 'Teste', iduff: 'A1')
      create(:dados_identificacao, identificacao_login: identificacao_login, cpf: '00000000000')
      usuario = create(:usuario, identificacao_login: identificacao_login)

      get autocomplete_usuario_identificacao_login_usuarios_path, params: { term: identificacao_login.iduff }, as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first['id']).to eq(usuario.id)
      expect(json.first['label']['id']).to eq(identificacao_login.id)
      expect(json.first['value']['id']).to eq(identificacao_login.id)
    end
  end
end
