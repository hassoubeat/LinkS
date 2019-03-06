Rails.application.routes.draw do
  get '/login_form', to: 'application#login_form', as: :login_form
  root :controller => 'application', :action => 'index'
end
