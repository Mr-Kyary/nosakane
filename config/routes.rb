Rails.application.routes.draw do
  root to: 'home#top'

  # ログイン関連(devise)
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

  ############resources############
  resources :students
  resources :companies
  resources :report_types
  resources :reports
  ############resources ここまで############

  ############get############
  get 'calendar/index'
  get 'calendar/callback'

  get "calendar/index", to:"calendar#index"
  get "oauth2callback", to:"calendar#callback"

  get 'home/students'
  get 'home/reports'
  get 'home/companies'
  ############get ここまで############

  ############post############
  post '/callback', to:'line_bot#callback'
  ############post ここまで############
end
