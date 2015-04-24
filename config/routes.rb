Rails.application.routes.draw do
  root to: 'repositories#index'
  resources :repositories, only: [:index, :create, :destroy]

  get '/auth/github/callback', to: 'auth#github'
  get '/sign_out', to: 'auth#sign_out', as: :sign_out

  resources :builds, only: :create
  scope '/*repo', repo: /.*/ do
    resources :builds, only: [:index, :show]
    root to: 'builds#index', as: :root_s
  end
end
