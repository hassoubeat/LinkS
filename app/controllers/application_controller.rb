class ApplicationController < ActionController::Base

  # 定数
  REDIS_USER_UNAUTH_PREFIX = "user_unauth_"
  REDIS_USER_UNAUTH_EXPIRE = "3600" #1時間
  USER_AUTH_ADMIN = "admin"

  protect_from_forgery with: :exception

  rescue_from Exception, with: :server_error
  rescue_from ActionController::RoutingError, with: :not_found

  helper_method :login_check?
  helper_method :login_id_check?
  helper_method :admin_check?

  before_action :login_check_filter
  before_action :init_action
  before_action :admin_check_filter, only: [:admin_index]
  around_action :around_logger

  skip_before_action :login_check_filter, only: [:index, :login_form, :raise_not_found]

  # トップ画面の表示
  def index
    # ログイン済みの場合は、ユーザページへリダイレクト
    if login_check?
      redirect_to "/users/#{@current_user.id}" and return
    end
    render template: 'index'
  end

  # 管理トップ画面の表示
  def admin_index
    render template: 'admin_index' ,layout: 'management'
  end

  # ログイン画面の表示
  def login_form
    render layout: 'login'
  end

  # NoRoutingError発生時に実行するアクション
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

    @current_user = User.new()
    @user = User.new()
    @folder = Folder.new()

    # ログインしていた場合、ログインユーザのデータをセット
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
    user_id = "NOT_LOGIN"
    if login_check?
      user_id = @current_user.email
    end
    logger.debug('START【' + method + '】:' + request_url + ", USER:" + user_id + ", TIME:" + Time.now.to_s)
    yield
    logger.debug(' END 【' + method + '】:' + request_url + ", USER:" + user_id + ", TIME:" + Time.now.to_s)
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

  # 管理者チェックフィルター
  def admin_check_filter
    if !admin_check?(@current_user.authority)
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

  # 管理者チェック
  def admin_check?(authority)
    if (authority == USER_AUTH_ADMIN)
      return true
    else
      return false
    end
  end

  # 404エラーページ
  def not_found(e)
    logger.error "error_404: #{e.message}"
    flash[:error] = "対象のページは存在しません"
    if login_check?
      redirect_to "/users/#{@current_user.id}" and return
    else
      redirect_to "/"
    end
  end

  # 500エラーページ
  def server_error(e)
    logger.error "error_500: #{e.message}"
    flash[:error] = "サーバエラーが発生しました"
    if login_check?
      redirect_to "/users/#{@current_user.id}" and return
    else
      redirect_to "/"
    end
  end
end
