Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  namespace :admin do
    resource :user_sessions, only: :create
  end
  ActiveAdmin.routes(self)
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: "pages#home"
end
