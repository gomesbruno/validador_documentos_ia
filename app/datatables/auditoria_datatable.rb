class AuditoriaDatatable
  delegate :params, :h, :link_to, :number_to_currency, :diff, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(_options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: PaperTrail::Version.count,
      iTotalDisplayRecords: versions.total_entries,
      aaData: data
    }
  end

  private

  def data
    versions.map do |version|
      [
        version.id,
        version.created_at.strftime('%d/%m/%Y - %H:%M:%S'),
        if version.whodunnit && version.whodunnit != 'Guest'
          version.whodunnit.titleize
        else
          'Guest'
        end,
        version.ip,
        version.item_type,
        version.event,
        teste(version)
      ]
    end
  end

  def versions
    @versions ||= fetch_versions
  end

  def teste(version)
    str = ''
    version.changeset.each do |k, (old, new)|
      str += "<style>#{Diffy::CSS}</style>
                  <div class='well diff'>
                  <p><strong>#{k}</strong>
                   #{diff(old, new)}
                   </p>
                   </div>"
    end
    str
  end

  def fetch_versions
    versions = PaperTrail::Version.order("#{sort_column} #{sort_direction}")
    versions = versions.page(page).per_page(per_page)
    if params[:sSearch]
      texto_pesquisa = []
      %w(id item_type object_changes item_id event whodunnit created_at).each do |term|
        texto_pesquisa << "#{term} like :search"
      end

      versions = versions.where(texto_pesquisa.join(' or '),
                                search: ActiveRecord::Base::sanitize_sql("%#{params[:sSearch]}%"))
    end

    versions
  end

  def page
    params[:iDisplayStart].to_i / per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == 'desc' ? 'desc' : 'asc'
  end
end
