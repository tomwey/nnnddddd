Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  
  # 网页
  resources :pages, path: :p, only: [:show]
  resources :videos, only: [:index, :create]
  
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount GrapeSwaggerRails::Engine => '/apidoc'
  mount API::Dispatch => '/api'
end
