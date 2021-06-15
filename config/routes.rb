Rails.application.routes.draw do
  get 'calendar/index'
  get 'calendar/callback'
  resources :students
  resources :companies
  resources :reports
  resources :report_types
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/callback' => 'line_bot#callback'
end
