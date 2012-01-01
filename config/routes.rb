Timesheets::Application.routes.draw do
  resources :projects do
    get :autocomplete_project_name, :on => :collection
    post :project_graph, :on => :collection
    get :show_my_statistics, :on => :collection
    get :my_graph, :on => :collection
  end
  
  resources :categories
  resources :time_entries
  resources :timesheets do 
    post 'load_timesheet', :on => :collection
  end
  

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get 'logout' => 'devise/sessions#destroy'
  end

  root :to=>"home#index"
  
  match '/projects/project_graph/:id' => 'projects#project_graph'
  match '/projects/static_graph/:id' => 'projects#static_graph'
  match '/projects/dynamic_graph/:id' => 'projects#dynamic_graph'
  match '/projects/my_graph/:id' => 'projects#my_graph'
end
