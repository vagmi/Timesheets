Timesheets::Application.routes.draw do
  resources :projects
  resources :categories
  resources :time_entries

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get 'logout' => 'devise/sessions#destroy'
  end

  root :to=>"home#index"
end
