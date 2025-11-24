require 'rails_helper'

describe Pub::IdentificacaoLogin, type: :model do
  subject(:identificacao_login) { create(:identificacao_login) }

  describe '#associations' do
    it { is_expected.to have_one(:usuario) }
  end

  describe '#scopes' do
    describe '.podem_ser_coordenador_ou_fiscal' do
      let!(:tecnico) do
        create :identificacao_tecnico_administrativo, nome: 'Tec123'
      end

      it 'deve retornar os usuários, que podem ser coordenador ou fiscal de projetos, por nome ou iduff' do
        result = described_class.podem_ser_coordenador_ou_fiscal('Tec')
        expect(result).to include(tecnico)
      end
    end

    describe '.ativo_por_nome_ou_iduff' do
      let!(:identificacao_login_generico) do
        create :identificacao_login_docente, nome: 'qlq123'
      end

      it 'deve retornar os usuários por nome ou iduff' do
        result = described_class.ativo_por_nome_ou_iduff('qlq')
        expect(result).to include(identificacao_login_generico)
      end
    end

    describe '.assistente_valido' do
      let!(:aluno) do
        create :identificacao_login_discente, nome: 'codepadawan', ativo: "\x01"
      end
      let!(:assistente_ativo) do
        create :identificacao_login_docente, nome: 'code master', ativo: "\x00"
      end
      let!(:assistente_inativo) do
        create :identificacao_tecnico_administrativo,
               nome: 'codenildo',
               ativo: "\x00"
      end
      let(:assistente_invalidado) do
        create :identificacao_login_discente, nome: 'codejedi', ativo: "\x00"
      end

      it 'deve retorna tecnicos e docente mesmo inativos' do
        result = described_class.assistente_valido 'code', 101
        expect(result).to include(assistente_inativo, assistente_ativo, aluno)
      end

      it 'deve retornar SOMENTE alunos com vinculo ativado' do
        class_scope = described_class.assistente_valido 'code', 101
        expect(class_scope).not_to include(assistente_invalidado)
      end
    end
  end

  describe '#methods' do
    describe '#autocomplete_display' do
      it 'deve retornar nome e iduff' do
        display = "#{identificacao_login.nome} - #{identificacao_login.iduff}"
        expect(identificacao_login.autocomplete_display).to eq(display)
      end
    end

    describe '#foto' do
      it 'deve retornar url para a foto' do
        sha = Digest::SHA1.hexdigest(identificacao_login.iduff.to_s)
        url = "https://sistemas.uff.br/static/identificacoes/oficial/#{sha}.jpg"
        expect(identificacao_login.foto).to eq(url)
      end
    end

    describe '#autocomplete_display_bolsista_discente' do
      let!(:identificacao_bolsista) { create :identificacao_login_discente }

      it 'deve retornar nome e matricula' do
        display = "#{identificacao_bolsista.nome} - "
        display << identificacao_bolsista.vinculacoes.first.matricula.to_s
        method = identificacao_bolsista.autocomplete_display_bolsista_discente
        expect(method).to eq(display)
      end
    end

    describe '#cargos' do
      let!(:presidente_fec) { create :identificacao_login_presidente_fec }
      let!(:funcionario) { create :funcionario }

      before do
        funcionario.vinculacao = presidente_fec.vinculacoes.first
        funcionario.save(validate: false)
      end

      it 'deve retornar os cargos, caso existam, associados à identificação login em questão' do
        expect(presidente_fec.cargos).to include(funcionario.cargo)
      end
    end

    describe '#funcionarios' do
      let!(:presidente_fec) { create :identificacao_login_presidente_fec }
      let!(:funcionario) { create :funcionario }

      before do
        funcionario.vinculacao = presidente_fec.vinculacoes.first
        funcionario.save(validate: false)
      end

      it 'deve retornar os funcionários, caso existam, associados à identificação login em questão' do
        expect(presidente_fec.funcionarios).to include(funcionario)
      end
    end
  end
end
