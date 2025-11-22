class Pub::Orgao < ActiveRecord::Base
  CATEGORIA_REITORIA = 5
  CATEGORIA_PRO_REITORIA = 11
  CATEGORIA_UNIDADE_UNIVERSITARIA = 17
  CATEGORIA_SUPERINTENDENCIA = 24
  CATEGORIA_UNIDADE_ACADEMICA = 424
  CATEGORIA_GABINETE = 484
  ID_PROPLAN = 10_223
  STATUS_ATIVO = 1

  scope :ativos, -> { where(status_orgao_id: STATUS_ATIVO) }
  scope :por_nome_sigla, lambda { |term|
                           where('descricao LIKE ? OR sigla LIKE ?',
                                 "%#{term.strip.tr(' ', '%')}%", "%#{term.strip.tr(' ', '%')}%")
                             .order(:descricao)
                         }
  scope :unidades_proponentes, lambda {
                                 where(categoria_orgao_id: [CATEGORIA_PRO_REITORIA,
                                                            CATEGORIA_UNIDADE_UNIVERSITARIA,
                                                            CATEGORIA_SUPERINTENDENCIA,
                                                            CATEGORIA_GABINETE])
                                   .where.not(orgao_pai_id: ID_PROPLAN)
                               }
  scope :proponente, ->(term) { ativos.unidades_proponentes.por_nome_sigla(term) }

  def autocomplete_display
    "#{descricao} - #{sigla}"
  end

  def self.orgaos_filhos(term, orgao_id)
    connection = ActiveRecord::Base.connection
    results = connection.execute("SELECT GROUP_CONCAT(lv SEPARATOR ',') as IDS FROM (
                                      SELECT @pv:=(SELECT GROUP_CONCAT(id SEPARATOR ',') FROM #{get_schema}.orgaos
                                      WHERE FIND_IN_SET(orgao_pai_id, @pv)) AS lv FROM #{get_schema}.orgaos
                                      JOIN
                                      (SELECT @pv:=#{orgao_id}) tmp) a;")
    ids = []
    ids.push(*results.first.first.split(',').map(&:to_i)) if results.first.first
    ids << orgao_id
    term = term.strip.tr(' ', '%')
    Pub::Orgao.where('id IN (?)', ids)
              .where("descricao LIKE '%#{term}%' or sigla LIKE '%#{term}%'")
              .order(:descricao)
  end

  def self.orgaos_ancestrais(orgao_id)
    connection = ActiveRecord::Base.connection
    query = "SELECT *
           	FROM (
                SELECT @pv:=(
                  SELECT GROUP_CONCAT(orgao_pai_id SEPARATOR ',')
                  FROM PUBLICO_PROD.orgaos
                  WHERE FIND_IN_SET(id, @pv) and nivel > 3) AS lv
                FROM PUBLICO_PROD.orgaos
                JOIN (SELECT @pv:=#{orgao_id}) tmp) a
	          where lv is not null;"
    results = connection.execute(query)
    ids = results.entries.flatten
    Pub::Orgao.find(ids)
  end

  # retorna os ancestrais exceto uff e reitoria
  def self.ancestrais(uorg)
    uff_reitoria = %w[1 10462]
    ids = Pub::Orgao.find_by(uorg: uorg).ancestrais.split('/') - uff_reitoria
    Pub::Orgao.where(id: ids.reverse)
  end

  def self.coseac
    Pub::Orgao.where("sigla like 'COSEAC'").where(status_orgao_id: STATUS_ATIVO).first
  end

  private_class_method def self.get_schema
    Pub::IdentificacaoLogin.get_schema_publico
  end
end
