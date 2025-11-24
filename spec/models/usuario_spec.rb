require 'rails_helper'

RSpec.describe Usuario, type: :model do
  subject(:usuario) { create(:usuario, identificacao_login: identificacao_login) }

  let(:identificacao_login) { create(:identificacao_login) }

  describe 'associations' do
    it { is_expected.to belong_to(:identificacao_login).class_name('Pub::IdentificacaoLogin') }
    it { is_expected.to have_many(:papeis).dependent(:destroy) }
    it { is_expected.to have_many(:perfis).through(:papeis) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identificacao_login) }

    it do
      create(:usuario, identificacao_login: identificacao_login)
      expect(usuario).to validate_uniqueness_of(:identificacao_login)
        .with_message('Cadastro Inválido! Usuário já existe.')
    end
  end

  describe '.por_iduff' do
    it 'retorna usuarios com iduff correspondente' do
      usuario
      outro_login = create(:identificacao_login, iduff: 'outro')
      create(:usuario, identificacao_login: outro_login)

      expect(Usuario.por_iduff(identificacao_login.iduff)).to contain_exactly(usuario)
    end
  end

  describe '.cria_sem_validar' do
    it 'cria um novo usuario quando inexistente' do
      expect do
        described_class.cria_sem_validar(identificacao_login.id)
      end.to change(described_class, :count).by(1)
    end

    it 'reaproveita usuario existente' do
      usuario_salvo = described_class.cria_sem_validar(identificacao_login.id)

      expect(described_class.cria_sem_validar(identificacao_login.id)).to eq(usuario_salvo)
    end
  end

  describe '.cria_perfil' do
    let(:perfil) { create(:perfil, tipo: 'assistente') }

    it 'associa perfil ao usuario' do
      usuario

      expect do
        described_class.cria_perfil(identificacao_login.id, perfil)
      end.to change { usuario.reload.perfis }.from([]).to([perfil])
    end
  end
end
