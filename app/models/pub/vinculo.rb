# -*- encoding : utf-8 -*-

class Pub::Vinculo < ActiveRecord::Base
  cattr_accessor :ALUNO, :PROFESSOR, :PROFESSOR_SUBSTITUTO, :TECNICO_ADMINISTRATIVO, :TERCEIRIZADO, :MEDICO_RESIDENTE, :ALUNO_POS, :ALUNO_EAD, :USUARIO_EXTERNO, :ALUNO_CURSO_SEQUENCIAL,
                 :PROFESSOR_COLABORADOR_VOLUNTARIO, :PESQUISADOR_DE_POS_DOUTORADO, :ALUNO_DE_DOUTORADO_SANDUICHE, :ALUNO_DE_MESTRADO_SANDUICHE
  cattr_accessor :VINCULO_BANCO_SEM_VINCULO, :VINCULO_BANCO_ALUNO, :VINCULO_BANCO_PROFESSOR, :VINCULO_BANCO_FUNCIONARIO, :VINCULO_BANCO_OUTROS

  has_many :vinculacoes

  @@ALUNO = 1
  @@PROFESSOR = 2
  @@PROFESSOR_SUBSTITUTO = 3
  @@TECNICO_ADMINISTRATIVO = 4
  @@TERCEIRIZADO = 5
  @@MEDICO_RESIDENTE = 6
  @@ALUNO_POS = 7
  @@ALUNO_EAD = 8
  @@USUARIO_EXTERNO = 9
  @@ALUNO_CURSO_SEQUENCIAL = 10
  @@PROFESSOR_COLABORADOR_VOLUNTARIO = 11
  @@PESQUISADOR_DE_POS_DOUTORADO = 12
  @@ALUNO_DE_DOUTORADO_SANDUICHE = 13
  @@ALUNO_DE_MESTRADO_SANDUICHE = 14

  @@VINCULO_BANCO_SEM_VINCULO = 0
  @@VINCULO_BANCO_ALUNO = 1
  @@VINCULO_BANCO_PROFESSOR = 2
  @@VINCULO_BANCO_FUNCIONARIO = 3
  @@VINCULO_BANCO_OUTROS = 4

  ARRAY_VINCULOS = [@@ALUNO, @@PROFESSOR, @@PROFESSOR_SUBSTITUTO, @@TECNICO_ADMINISTRATIVO, @@TERCEIRIZADO, @@MEDICO_RESIDENTE, @@ALUNO_POS, @@ALUNO_EAD, @@USUARIO_EXTERNO, @@ALUNO_CURSO_SEQUENCIAL,
                    @@PROFESSOR_COLABORADOR_VOLUNTARIO, @@PESQUISADOR_DE_POS_DOUTORADO, @@ALUNO_DE_DOUTORADO_SANDUICHE, @@ALUNO_DE_MESTRADO_SANDUICHE]

  VINCULOS_ALUNOS = [@@ALUNO,
                     @@ALUNO_POS,
                     @@ALUNO_EAD,
                     @@ALUNO_CURSO_SEQUENCIAL,
                     @@ALUNO_DE_DOUTORADO_SANDUICHE,
                     @@ALUNO_DE_MESTRADO_SANDUICHE,
                     @@PESQUISADOR_DE_POS_DOUTORADO
                     ]

  VINCULOS_DOCENTES_TECNICOS = [@@PROFESSOR,
                                @@PROFESSOR_SUBSTITUTO,
                                @@TECNICO_ADMINISTRATIVO]

  def self.pegar_nome_vinculo(numero)
    case numero
    when @@ALUNO
      'Alunos'
    when @@PROFESSOR
      'Professores'
    when @@PROFESSOR_SUBSTITUTO
      'Professores'
    when @@TECNICO_ADMINISTRATIVO
      'Tecnicos Administrativos'
    when @@TERCEIRIZADO
      'Terceirizados'
    when @@MEDICO_RESIDENTE
      'Médicos Residentes'
    when @@ALUNO_POS
      'Alunos de Pós-Graduação'
    when @@ALUNO_EAD
      'Alunos de Ensino à Distância'
    when @@USUARIO_EXTERNO
      'Usuário Externo'
    when @@ALUNO_CURSO_SEQUENCIAL
      'Alunos de Curso Sequencial da Graduação'
    end
  end

  def self.nome_padrao(status)
    case status
    when @@ALUNO
      'Aluno'
    when @@PROFESSOR
      'Professor'
    when @@PROFESSOR_SUBSTITUTO
      'Professor Substituto'
    when @@TECNICO_ADMINISTRATIVO
      'Tecnico Administrativo'
    when @@TERCEIRIZADO
      'Terceirizado'
    when @@MEDICO_RESIDENTE
      'Médico Residente'
    when @@ALUNO_POS
      'Aluno de Pós-Graduação'
    when @@ALUNO_EAD
      'Aluno de Ensino à Distância'
    when @@USUARIO_EXTERNO
      'Usuário Externo'
    when @@ALUNO_CURSO_SEQUENCIAL
      'Aluno de Curso Sequencial da Graduação'
    end
  end
end
