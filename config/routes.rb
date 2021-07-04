Rails.application.routes.draw do

  ############resources############
  resources :students
  resources :companies
  resources :report_types
  resources :reports
  ############resources ここまで############

  ############get############
  get 'user/index', to: 'users#index'
  get 'home/students'
  get 'home/reports'
  get 'home/companies'
  get 'calendar/index', to: 'calendar#index'
  get '/about', to:'home#about'
  ############get ここまで############

  ############post############
  post '/callback', to:'line_bot#callback'
  post 'users/sign_up'
  ############post ここまで############

  # ログイン関連(devise)
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

  root to: 'home#top'
end
