Rails.application.routes.draw do
  get '/users/new', to: 'users#new', as: :new_user
  post '/users', to: 'users#create'
  get '/login_form', to: 'application#login_form', as: :login_form
  root :controller => 'application', :action => 'index'
end
