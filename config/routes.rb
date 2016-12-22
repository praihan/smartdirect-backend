Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'health-check' => 'health_check#index'

  namespace :api do
    namespace :v1 do
      get 'current-user' => 'current_user#index'
      get 'current-directory' => 'current_directory#index'

      jsonapi_resources :users
      jsonapi_resources :directories
    end
  end

end
