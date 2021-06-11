Rails.application.routes.draw do
  resources :students
  resources :report_types
  resources :companies
  resources :reports
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
