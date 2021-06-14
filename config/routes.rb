Rails.application.routes.draw do
  resources :students
  resources :companies
  resources :reports
  resources :report_types
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
