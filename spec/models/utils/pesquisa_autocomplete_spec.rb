require 'rails_helper'

RSpec.describe Utils::PesquisaAutocomplete, type: :model do
  describe '.pesquisar' do
    context 'quando pesquisa por órgao' do
      let(:status_orgao) { Pub::StatusOrgao.find_or_create_by(id: 1) }
      let!(:orgao_pai) do
        create(:orgao, status_orgao: status_orgao)
      end
      let(:params) { { search_mode: 'orgao', term: orgao_pai.sigla } }

      before do
        orgao_pai.categoria_orgao_id = Pub::Orgao::CATEGORIA_PRO_REITORIA
        orgao_pai.orgao_pai_id = 1
        orgao_pai.save(validate: false)
      end

      it 'retorna por órgaos' do
        result = Utils::PesquisaAutocomplete.new(params).pesquisar
        expect(result).to include(orgao_pai)
      end
    end

    context 'quando pesquisa por departamento' do
      let!(:orgao_pai) { create(:orgao) }
      let!(:orgao_filho) { create(:orgao, orgao_pai_id: orgao_pai.id) }
      let(:params) { { search_mode: 'departamento', term: orgao_filho.descricao, orgao_id: orgao_pai.id } }

      before do
        orgao_pai.categoria_orgao_id = Pub::Orgao::CATEGORIA_PRO_REITORIA
        orgao_pai.orgao_pai_id = 1
        orgao_pai.save(validate: false)
      end

      it 'retorna departamentos' do
        result = Utils::PesquisaAutocomplete.new(params).pesquisar
        expect(result).to include(orgao_filho)
      end
    end

    context 'quando pesquisa por identificacao login' do
      let!(:coordenador) { create(:usuario, :coordenador).identificacao_login }
      let(:params) { { search_mode: 'identificacao', term: coordenador.nome } }

      it 'retorna identificacao login' do
        result = Utils::PesquisaAutocomplete.new(params).pesquisar
        expect(result).to include(coordenador)
      end
    end

    context 'quando pesquisa por subcoordenador de projeto' do
      let(:status_orgao) { Pub::StatusOrgao.find_or_create_by(id: 1) }
      let!(:lotacao) { create(:orgao, status_orgao: status_orgao) }
      let!(:coordenador) { create(:funcionario, lotacao_exercicio: lotacao) }
      let!(:subcoordenador) { create(:funcionario, lotacao_exercicio: lotacao) }
      let(:params) do
        { search_mode: 'subcoordenador_projeto',
          coordenador_id: coordenador.vinculacao.identificacao_login.id,
          term: subcoordenador.nome }
      end

      it 'retorna possíveis subcoordenadores de projeto' do
        result = Utils::PesquisaAutocomplete.new(params).pesquisar
        expect(result).to include(subcoordenador.vinculacao.identificacao_login)
      end
    end

    context 'quando pesquisa por plap' do
      let(:funcionario_plap) { create(:usuario, :funcionario_plap).identificacao_login }
      let(:params) { { search_mode: 'plap', term: funcionario_plap.nome } }

      it 'retorna usuários da PLAP' do
        result = Utils::PesquisaAutocomplete.new(params).pesquisar
        expect(result).to include(funcionario_plap)
      end
    end

    context 'quando pesquisa por projeto' do
      let(:projeto) { create(:projeto_ped) }
      let(:params) { { search_mode: 'projeto', term: projeto.titulo_projeto } }

      it 'retorna projetos' do
        result = Utils::PesquisaAutocomplete.new(params).pesquisar
        expect(result).to include(projeto)
      end
    end

    context 'quando pesquisa por projeto tripartite' do
      let(:projeto) { create(:tripartite_projeto) }
      let(:params) { { search_mode: 'projeto_tripartite', term: projeto.titulo_projeto } }

      it 'retorna projetos' do
        result = Utils::PesquisaAutocomplete.new(params).pesquisar
        expect(result).to include(projeto)
      end
    end
  end
end
