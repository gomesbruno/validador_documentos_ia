class UsuariosController < ApplicationController
  # load_and_authorize_resource
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]

  autocomplete :usuario, :identificacao_login,
               display_value: :autocomplete_display, extra_data: [:id]

  # # se usar gem rails-jquery-autocomplete
  # autocomplete :usuario, :identificacao_login

  def index
    @usuarios = Usuario.joins(:identificacao_login).order(nome: :asc)
    respond_to do |format|
      format.html { render 'index.html', locals: { colunas: colunas_usuarios } }
      format.json do

        render json: UsuariosDatatable.new(view_context)
      end
    end
  end

  def new
    @usuario = Usuario.new
  end

  def create
    puts "create action called"
    resp = UsuarioService.criar_usuario(
      params[:usuario][:identificacao_login_id],
      perfil_params
    )
    redirect_to usuarios_path, notice: resp[:notice], alert: resp[:alert]
  end

  def edit
  end

  def update
    resp = UsuarioService.modifica_perfil @usuario, perfil_params
    redirect_to usuarios_path, notice: resp[:notice], alert: resp[:alert]
  end

  def destroy
    @usuario.destroy
    respond_to do |format|
      format.html { redirect_to usuarios_url, notice: 'Usuário foi deletado com sucesso'}
      format.json { head :no_content }
    end
  end

  def autocomplete
    puts "Autocomplete action called"
  end



  # ou action manual
  def autocomplete_usuario_identificacao_login
    @results = Usuario.por_iduff_ou_nome(params[:term]).limit(10)
    render json: @results.map { |u| { id: u.id, label: u.identificacao_login, value: u.identificacao_login } }
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_usuario
    @usuario = Usuario.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def usuario_params
    params.require(:usuario).permit(:identificacao_login_id)
  end

  def perfil_params
    params[:usuario][:opcoes_perfil]
  end

  # SOBRESCREVENDO MÉTODO DA GEM DE AUTOCOMPLETE PARA USAR SCOPE COM PARAMETRO
  def get_autocomplete_items(parameters)
    ApplicationService.autocomplete(params)
  end

  def colunas_usuarios
    %w[Nome Perfis Ações]
  end


end
