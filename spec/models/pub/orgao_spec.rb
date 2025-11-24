require 'rails_helper'

describe Pub::Orgao do
  subject(:orgao) { create(:orgao) }

  describe '#rsmethods' do
    describe '.autocomplete_display' do
      it 'deve ser igual ao nome' do
        expect(orgao.autocomplete_display).to eq "#{orgao.descricao} - #{orgao.sigla}"
      end
    end

    describe '.orgaos_filhos' do
      let!(:orgao_pai) { create(:orgao) }
      let!(:orgao_filho) { create(:orgao, orgao_pai_id: orgao_pai.id) }

      it 'deve retornar apenas orgao_filho' do
        result = Pub::Orgao.orgaos_filhos(orgao_filho.descricao, orgao_pai.id)
        expect(result).to match [orgao_filho]
      end

      it 'deve retornar ambos orgao_pai e orgao_filho' do
        result = Pub::Orgao.orgaos_filhos('ORG', orgao_pai.id)
        expect(result).to match [orgao_pai, orgao_filho]
      end
    end

    describe '.por_nome_sigla' do
      let!(:status_orgao) { Pub::StatusOrgao.find_or_create_by(id: 1) }
      let!(:orgao_teste) { create(:orgao, status_orgao: status_orgao) }

      context 'quando a sigla/descrição existe' do
        it 'deve retornar orgao que possua a sigla/descricao passada como paramêtro' do
          expect(Pub::Orgao.por_nome_sigla(orgao_teste.descricao)).to include(orgao_teste)
        end
      end

      context 'quando a sigla/descricao não existe' do
        it 'não deve retornar nenhum orgao' do
          expect(Pub::Orgao.por_nome_sigla('00000000000')).not_to include(orgao_teste)
        end
      end
    end
  end
end
