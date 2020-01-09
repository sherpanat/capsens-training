Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: "homes#show"
  namespace :users do
    resource :dashboards, only: :show
  end
  resources :projects, only: [:show, :index] do
    resources :contributions, only: [:new, :create]
  end
end
