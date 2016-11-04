Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'health-check' => 'health_check#index'

  jsonapi_resources :users
  jsonapi_resources :link_directories
end
