Rails.application.routes.draw do

  # ログイン関連(devise)
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
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
  get 'home/students'
  get 'home/reports'
  get 'home/companies'
  get 'calendar/index', to: 'calendar#index'
  ############get ここまで############

  ############post############
  post '/callback', to:'line_bot#callback'
  ############post ここまで############

  root to: 'home#top'
end
