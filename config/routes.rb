Timesheets::Application.routes.draw do
  resources :projects
  resources :categories
  resources :time_entries

  devise_for :users

  root :to=>"home#index"
end
