Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'health-check' => 'health_check#index'

  get 'current-user' => 'current_user#index'

  jsonapi_resources :users
  jsonapi_resources :directories
end
