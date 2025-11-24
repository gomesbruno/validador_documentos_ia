require 'rails_helper'

describe Pub::Vinculo do
  let(:vinculo) { Pub::Vinculo.new }
  subject { vinculo }

  describe '#associações' do
    it {is_expected.to have_many(:vinculacoes)}
  end
  describe '#métodos' do

    describe '.pegar_nome_vinculo' do
      context 'quando for aluno' do
        it 'Deve retornar "Alunos"' do
          expect(Pub::Vinculo.pegar_nome_vinculo(Pub::Vinculo.ALUNO)).to eq('Alunos')
        end
      end

      context 'quando for professor' do
        it 'Deve retornar "Professores"' do
          expect(Pub::Vinculo.pegar_nome_vinculo(Pub::Vinculo.PROFESSOR)).to eq('Professores')
        end
      end

      context 'quando for professor substituto' do
        it 'Deve retornar "Professores"' do
          expect(Pub::Vinculo.pegar_nome_vinculo(Pub::Vinculo.PROFESSOR_SUBSTITUTO)).to eq('Professores')
        end
      end

      context 'quando for técnico administrativo' do
        it 'Deve retornar "Tecnicos Administrativos"' do
          expect(Pub::Vinculo.pegar_nome_vinculo(Pub::Vinculo.TECNICO_ADMINISTRATIVO)).to eq('Tecnicos Administrativos')
        end
      end

      context 'quando for médico residente' do
        it 'Deve retornar "Médicos Residentes"' do
          expect(Pub::Vinculo.pegar_nome_vinculo(Pub::Vinculo.MEDICO_RESIDENTE)).to eq('Médicos Residentes')
        end
      end

      context 'quando for terceirizado' do
        it 'Deve retornar "Terceirizados"' do
          expect(Pub::Vinculo.pegar_nome_vinculo(Pub::Vinculo.TERCEIRIZADO)).to eq('Terceirizados')
        end
      end

      context 'quando for aluno de pós' do
        it 'Deve retornar "Alunos de Pós-Graduação"' do
          expect(Pub::Vinculo.pegar_nome_vinculo(Pub::Vinculo.ALUNO_POS)).to eq('Alunos de Pós-Graduação')
        end
      end

      context 'quando for aluno de EAD' do
        it 'Deve retornar "Alunos de Ensino à Distância"' do
          expect(Pub::Vinculo.pegar_nome_vinculo(Pub::Vinculo.ALUNO_EAD)).to eq('Alunos de Ensino à Distância')
        end
      end

      context 'quando for usuário externo' do
        it 'Deve retornar "Usuário Externo"' do
          expect(Pub::Vinculo.pegar_nome_vinculo(Pub::Vinculo.USUARIO_EXTERNO)).to eq('Usuário Externo')
        end
      end

      context 'quando for aluno de curso sequencial' do
        it 'Deve retornar "Alunos de Curso Sequencial da Graduação"' do
          expect(Pub::Vinculo.pegar_nome_vinculo(Pub::Vinculo.ALUNO_CURSO_SEQUENCIAL)).to eq('Alunos de Curso Sequencial da Graduação')
        end
      end
    end


    describe '.nome_padrao' do
      context 'quando for aluno' do
        it 'Deve retornar "Aluno"' do
          expect(Pub::Vinculo.nome_padrao(Pub::Vinculo.ALUNO)).to eq('Aluno')
        end
      end

      context 'quando for professor' do
        it 'Deve retornar "Professor"' do
          expect(Pub::Vinculo.nome_padrao(Pub::Vinculo.PROFESSOR)).to eq('Professor')
        end
      end

      context 'quando for professor substituto' do
        it 'Deve retornar "Professor Substituto"' do
          expect(Pub::Vinculo.nome_padrao(Pub::Vinculo.PROFESSOR_SUBSTITUTO)).to eq('Professor Substituto')
        end
      end

      context 'quando for técnico administrativo' do
        it 'Deve retornar "Tecnico Administrativo"' do
          expect(Pub::Vinculo.nome_padrao(Pub::Vinculo.TECNICO_ADMINISTRATIVO)).to eq('Tecnico Administrativo')
        end
      end

      context 'quando for médico residente' do
        it 'Deve retornar "Médico Residente"' do
          expect(Pub::Vinculo.nome_padrao(Pub::Vinculo.MEDICO_RESIDENTE)).to eq('Médico Residente')
        end
      end

      context 'quando for terceirizado' do
        it 'Deve retornar "Terceirizado"' do
          expect(Pub::Vinculo.nome_padrao(Pub::Vinculo.TERCEIRIZADO)).to eq('Terceirizado')
        end
      end

      context 'quando for aluno de pós' do
        it 'Deve retornar "Aluno de Pós-Graduação"' do
          expect(Pub::Vinculo.nome_padrao(Pub::Vinculo.ALUNO_POS)).to eq('Aluno de Pós-Graduação')
        end
      end

      context 'quando for aluno de EAD' do
        it 'Deve retornar "Aluno de Ensino à Distância"' do
          expect(Pub::Vinculo.nome_padrao(Pub::Vinculo.ALUNO_EAD)).to eq('Aluno de Ensino à Distância')
        end
      end

      context 'quando for usuário externo' do
        it 'Deve retornar "Usuário Externo"' do
          expect(Pub::Vinculo.nome_padrao(Pub::Vinculo.USUARIO_EXTERNO)).to eq('Usuário Externo')
        end
      end

      context 'quando for aluno de curso sequencial' do
        it 'Deve retornar "Aluno de Curso Sequencial da Graduação"' do
          expect(Pub::Vinculo.nome_padrao(Pub::Vinculo.ALUNO_CURSO_SEQUENCIAL)).to eq('Aluno de Curso Sequencial da Graduação')
        end
      end
    end

  end
end

