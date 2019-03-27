class ApplicationController < ActionController::Base

  # 定数
  REDIS_USER_UNAUTH_PREFIX = "user_unauth_"
  REDIS_USER_UNAUTH_EXPIRE = "3600" #1時間

  protect_from_forgery with: :exception

  helper_method :login_check?
  helper_method :login_id_check?

  before_action :login_check_filter
  before_action :init_action
  around_action :around_logger

  skip_before_action :login_check_filter, only: [:index, :login_form]

  # トップ画面の表示
  def index
    # ログイン済みの場合は、ユーザページへリダイレクト
    if login_check?
      redirect_to "/users/#{@current_user.id}" and return
    end
    render template: 'index'
  end

  # ログイン画面の表示
  def login_form
    render layout: 'login'
  end

  def raise_not_found
    raise ActionController::RoutingError, "No route matches #{params[:unmatched_route]}"
  end

  private

  # 汎用的な初期化処理
  def init_action
    # 画面遷移時にサイドバーを表示するフラグ(基本スマホのみに適用)
    @intial_display_sidebar = false
    # 画面遷移時に詳エリアを表示するフラグ
    @intial_display_detail_area = false

    @user = User.new()
    @folder = Folder.new()

    # ログインしていた場合、テンプレート変数にログインユーザのデータをセット
    if login_check?
      @current_user = User.find(session[:user_id])
    end

    # パラメータでユーザIDを受けている時に、ユーザ情報を取得する
    if params[:user_id]
      @user = User.find(params[:user_id])
    end

    # パラメータでフォルダーIDを受けている時に、フォルダー情報を取得する
    if params[:folder_id]
      @folder = Folder.find(params[:folder_id])
    end

    # ユーザIDを取得できた際には、紐づくフォルダー一覧を取得する
    if @user
      @folders = Folder.where(user_id: @user.id).is_valid
    end
  end

  # アクションの前後でログを出力
  def around_logger
    method = request.method
    request_url = request.url
    logger.debug('START【' + method + '】:' + request_url + ", TIME:" + Time.now.to_s)
    yield
    logger.debug(' END 【' + method + '】:' + request_url + ", TIME:" + Time.now.to_s)
  end

  protected

  # ログインチェックフィルター
  def login_check_filter
    if !login_check?
      redirect_to controller: 'application', action: 'index'
    end
  end

  # ログイン本人チェックフィルター
  def login_id_check_filter
    if !login_id_check?(params[:user_id].to_i)
      # 自分のTOPページへ
      @folders = Folder.where(user_id: @current_user.id).is_valid
      redirect_to "/users/#{@current_user.id}" and return
    end
  end

  # ログインチェック
  def login_check?
    if session[:user_id]
      return true
    else
      return false
    end
  end

  # ログイン本人チェック
  def login_id_check?(user_id)
    if (session[:user_id] == user_id)
      return true
    else
      return false
    end
  end
end
