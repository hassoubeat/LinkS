class FoldersController < ApplicationController
  skip_before_action :login_check, only: [:create, :user_check, :login]
  before_action :login_user_check, only: [:create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/:user_id/folders/:folder_id
  def show
    # TODO 紐付いているリンクを取得
    render layout: "main"
  end

  # POST /users/:user_id/folders
  def create
    @folder = Folder.new(folder_params)
    @folder.is_valid = true
    @folder.user_id = session[:user_id]

    # フォルダー名が入力されていない時は、デフォルト名で登録する
    if @folder.name == ""
      @folder.name = FOLDER_DEFAULT_NAME
    end

    # TODO バリデーションチェック
    # if @user.invalid?
    #   render :new, layout: "application" and return
    # end

    if @folder.save
      flash[:info] = "フォルダーを登録しました"
    else
      # TODO システムエラー
      flash[:info] = "フォルダーの登録に失敗しました"
    end
    redirect_to "/users/#{session[:user_id]}" and return
  end

  # PATCH /users/:user_id/folders/:folder_id
  def update
    # TODO バリデーションチェック
    # if @user.invalid?
    #   render :new, layout: "application" and return
    # end

    if @folder.update(folder_params)
      flash[:info] = "フォルダーを変更しました"
    else
      # TODO システムエラー
      flash[:info] = "フォルダーの変更に失敗しました"
    end
    redirect_to "/users/#{session[:user_id]}/folders/#{@folder.id}}" and return
  end

  # DELETE /users/:user_id/folders/:folder_id
  def destroy
    @folder.is_valid = false;
    if @folder.save
      flash[:info] = "フォルダーを削除しました"
    else
      # TODO システムエラー
      flash[:info] = "フォルダーの削除に失敗しました"
    end
    redirect_to "/users/#{session[:user_id]}" and return
  end

  private
    def folder_params
      params.require(:folder).permit(:name, :comment, :is_open)
    end
end
