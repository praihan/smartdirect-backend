Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'health-check' => 'health_check#index'
  post 'api' => 'graphql#execute'
end
