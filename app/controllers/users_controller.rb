class UsersController < ApplicationController
  skip_before_action :login_check_filter, only: [:new, :create, :user_check, :login]
  before_action :login_id_check_filter, only: [:show, :edit]

  # GET /users/:user_id
  def show
    @intial_display_sidebar = true;
    @newses = News.all.is_valid.is_open.created_at_desc.limit(10)
    render layout: "main"
  end

  # GET /users/new
  def new
    @user = User.new
    render layout: "application"
  end

  # GET /users/edit/:user_id
  def edit
    render layout: "main"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.is_valid = true;

    # バリデーションチェック
    if @user.invalid?
      render :new, layout: "application" and return
    end

    # Redisに保存するためにハッシュデータの作成
    user_hash = @user.attributes

    # Redisに登録する際のランダムなkey値を取得
    rand_param = SecureRandom.hex
    key = REDIS_USER_UNAUTH_PREFIX + rand_param

    # Redisにユーザ情報を保存
    redis = Redis.new
    redis.multi do
      redis.mapped_hmset key, user_hash
      redis.expire(key, REDIS_USER_UNAUTH_EXPIRE)
    end
    logger.debug("email:" + @user.email + ", Redis_key:" + key);

    # 認証メールの送付
    EmailCheckMailer.send_user_email_check(user_hash, rand_param).deliver_later

    flash[:info] = "入力頂いたメールアドレスに認証用のメールを送付致しました。1時間以内に認証を行って本登録を完了させてください。"
    redirect_to controller: 'application', action: 'index'
  end

  # PATCH /users/:user_id
  def update
    if @user.update(params.require(:user).permit(:password, :password_confirmation, :name))
      flash[:info] = "ユーザ情報を更新しました"
      redirect_to "/users/edit/#{@user.id}" and return
    else
      render template: "/users/edit", layout: "main" and return
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # メールアドレス本認証(認証が取れればデータベースにアカウントを登録)
  def user_check
    authcode = REDIS_USER_UNAUTH_PREFIX + params[:authcode]
    redis = Redis.new
    user = redis.hgetall authcode
    logger.debug user.inspect
    if user.empty?
      # redisからユーザ情報が取得できなかった場合は、再度登録を促す
      flash.now[:error] = "ユーザ認証期限を過ぎています。お手数ですがユーザ登録から再度行ってください。"
      render template: "index" and return
    else
      # ユーザ情報をmodelにセットする
      @user = User.new(
        email: user['email'],
        password_digest: user['password_digest'],
        name: user['name'],
        is_valid: user['is_valid']
      )
    end

    respond_to do |format|
      if @user.save
        flash[:info] = "ユーザ登録が完了しました。"
        format.html { redirect_to controller: 'application', action: 'index'}
        # format.json { render :show, status: :created, location: @user }
      else
        # TODO システムエラー
        format.html { render template: "index" and return}
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # ログイン処理
  def login
    @user = User.find_by(email: params[:email])
    # ハッシュ化したパスワードで認証
    if @user && @user.authenticate(params[:password]);
      # ログイン成功後、セッションIDをリセット(セッション固定攻撃、セッションハイジャック対策)
      reset_session
      session[:user_id] = @user.id
      redirect_to "/users/#{@user.id}"
    else
      flash.now[:error] = "メールアドレスまたはパスワードが間違っています"
      @user = User.new
      @email = params[:email]
      @password = params[:password]

      render template: "index"
    end
  end

  # ログアウト処理
  def logout
    session[:user_id] = nil
    flash[:info] = "ログアウトしました"
    redirect_to controller: 'application', action: 'index'
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end
end
