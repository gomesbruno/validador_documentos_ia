Rails.application.routes.draw do

  resources :usuarios do
     get :autocomplete_usuario_identificacao_login, on: :collection
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
end
