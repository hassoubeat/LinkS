class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :login_check, only: [:new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    render layout: "login"
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.is_valid = true;

    # バリデーションチェック
    if @user.invalid?
      render :new, layout: "login" and return
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
    EmailCheckMailer.send_user_email_check(user_hash, rand_param).deliver

    flash[:info] = "入力頂いたメールアドレスに認証用のメールを送付致しました。1時間以内に認証を行って本登録を完了させてください。"
    redirect_to controller: 'application', action: 'index'
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
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

  # メールアドレス認証(認証が取れればデータベースにアカウントを登録)
  def user_check
    authcode = REDIS_USER_UNAUTH_PREFIX + params[:authcode]
    redis = Redis.new
    user = redis.hgetall authcode
    if user
      # ユーザ情報をmodelにセットする
      @user = User.new(
        email: user['email'],
        password_digest: user['password_digest'],
        name: user['name'],
        is_valid: user['is_valid']
      )
    else
      # redisからユーザ情報が取得できなかった場合は、再度登録を促す
      flash.now[:error] = "ユーザ認証期限を過ぎています。再度ユーザ登録から行ってください。"
      render :login_form and return
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, flash: {info: 'ユーザ登録が完了しました。'}}
        format.json { render :show, status: :created, location: @user }
      else
        # TODO システムエラー
        format.html { render :login_form}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end
end
