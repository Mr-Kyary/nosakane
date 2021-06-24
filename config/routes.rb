Rails.application.routes.draw do
  root to: 'home#top'

  # ログイン関連(devise)
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

  get 'calendar/index'
  get 'calendar/callback'

  resources :students
  resources :companies
  resources :report_types
  resources :reports
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/callback' => 'line_bot#callback'

  get "calendar/index", to:"calendar#index"
  get "oauth2callback", to:"calendar#callback"

  get 'home/students'
  get 'home/reports'
  get 'home/companies'
end
