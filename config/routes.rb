Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  namespace :users do
    resource :verifications, only: [:new, :create]
  end
end
