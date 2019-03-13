Rails.application.routes.draw do
  # トップページ
  get '/', to: 'application#index'
  # ユーザ登録ページ
  get '/users/new', to: 'users#new', as: :new_user
  # ユーザ登録処理
  post '/users', to: 'users#create'
  # ユーザ登録本認証処理
  get '/user_check', to: 'users#user_check'
  # ユーザ詳細ページ
  get '/users/:id', to: 'users#show'
  # ログイン
  post '/login', to: 'users#login'
  # ルート
  root :controller => 'application', :action => 'index'
end
