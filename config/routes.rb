Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: "pages#home"
  get 'dashboard', to: 'pages#dashboard', as: :dashboard
end
