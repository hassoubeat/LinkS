class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :login_user?

  before_action :login_check
  before_action :init_action
  around_action :around_logger

  skip_before_action :login_check, only: [:index,:login_form]

  # トップ画面の表示
  def index
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
    # ログインしていた場合、テンプレート変数にログインユーザのデータをセット
    if session[:user_id]
      @current_user = User.find(session[:user_id])
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
  def login_check
    unless session[:user_id]
      redirect_to(:index)
    end
  end

  # ログイン本人チェック
  def login_user?(user_id)
    if (session[:user_id] == user_id)
      return true
    else
      return false
    end
  end
end
