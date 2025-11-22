class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # authenticate_with_iduff_keycloak

  helper_method :identificacao_corrente


  def identificacao_corrente
    Pub::IdentificacaoLogin.find_by(iduff: current_user.iduff) if current_user
  end
  def user_for_paper_trail
    # Save the user responsible for the action
    "#{identificacao_corrente.nome.titleize} - #{identificacao_corrente.iduff}" if identificacao_corrente
  end
  # O projeto já vem com a gem do portal (iduff-keycloak_client) incluída
  # A gem do portal te dá os seguintes métodos:

  # current_user (com current_user.iduff e current_user.ip)
  # logged_in? (true ou false, status do login no portal)
end
