Rails.application.routes.draw do
  # トップページ
  get '/', to: 'application#index'
  # ユーザ登録ページ
  get '/users/new', to: 'users#new', as: :new_user
  # ユーザ変更ページ
  get '/users/edit/:user_id', to: 'users#edit'
  # ユーザ登録処理
  post '/users', to: 'users#create'
  # ユーザ変更処理
  patch '/users/:user_id', to: 'users#update'
  # ユーザ登録本認証処理
  get '/user_check', to: 'users#user_check'
  # ユーザ詳細ページ
  get '/users/:user_id', to: 'users#show'
  # フォルダー登録ページ
  post '/users/:user_id/folders', to: 'folders#create'
  # フォルダー詳細ページ
  get '/users/:user_id/folders/:folder_id', to: 'folders#show'
  # フォルダー変更処理
  patch '/users/:user_id/folders/:folder_id', to: 'folders#update'
  # フォルダー削除処理
  delete '/users/:user_id/folders/:folder_id', to: 'folders#destroy'
  # フォルダーソート処理
  get '/users/:user_id/folders/sort/:folder_sort_ids', to: 'folders#sort'
  # フォルダーいいね！処理
  get '/users/:user_id/folders/:folder_id/like', to: 'folders#like'
  # リンク登録処理
  post '/users/:user_id/folders/:folder_id/links/', to: 'links#create'
  # リンク変更処理
  patch '/users/:user_id/folders/:folder_id/links/:link_id', to: 'links#update'
  # リンク削除処理
  delete '/users/:user_id/folders/:folder_id/links/:link_id', to: 'links#destroy'
  # リンクソート処理
  get '/users/:user_id/folders/:folder_id/links/sort/:link_sort_ids', to: 'links#sort'
  # ログイン
  post '/login', to: 'users#login'
  # ログアウト
  get '/logout', to: 'users#logout'
  # 管理トップページ(管理画面)
  get '/management', to: 'application#admin_index'
  # ニュース一覧ページ(管理画面)
  get '/management/news', to: 'news#index'
  # ニュース登録ページ(管理画面)
  get '/management/news/new', to: 'news#new'
  # ニュース登録処理(管理画面)
  post '/management/news', to: 'news#create'
  # ニュース変更処理(管理画面)
  get '/management/news/edit/:news_id', to: 'news#edit'
  # ニュース変更処理(管理画面)
  patch '/management/news/:news_id', to: 'news#update'
  # ニュース削除処理(管理画面)
  delete '/management/news/:news_id', to: 'news#destroy'
  # ルート
  root :controller => 'application', :action => 'index'
  # ルーティングエラー
  match '*unmatched_route', via: :all, to: 'application#raise_not_found', format: false
end
