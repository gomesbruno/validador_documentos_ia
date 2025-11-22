class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Versiona create/update/destroy de TUDO por padrão
  has_paper_trail on: %i[create update destroy]


  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end
end
