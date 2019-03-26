class FoldersController < ApplicationController

  helper_method :folder_liked?

  skip_before_action :login_check, only: [:show, :create, :user_check, :login]
  before_action :login_user_check, only: [:create, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/:user_id/folders/:folder_id
  def show
    # 本人以外がアクセスする時、公開されていない場合はTOPに
    if login_user?(@user.id) or @folder.is_open
      @links = Link.where(folder_id: @folder.id).is_valid
      # 本人以外がアクセスしたときには、詳細メッセージエリアを初期表示する
      if !login_user?(@user.id)
        @intial_display_detail_area = true
      end
      render layout: "main"
    else
      flash[:info] = "公開されていないフォルダーもしくはフォルダーが存在しません"
      redirect_to "/users/#{@user.id}" and return
    end
  end

  # POST /users/:user_id/folders
  def create

    # 登録上限数のチェック
    if @folders.count() >= Folder::FOLDER_CREATE_LIMIT
      flash[:error] = "フォルダーの登録上限に達しています"
      redirect_to "/users/#{session[:user_id]}" and return
    end

    @folder = Folder.new(folder_params)
    @folder.is_valid = true
    @folder.sort = Folder::FOLDER_DEFAULT_SORT
    @folder.user_id = session[:user_id]

    # フォルダー名が入力されていない時は、デフォルト名で登録する
    if @folder.name == ""
      @folder.name = Folder::FOLDER_DEFAULT_NAME
    end

    if @folder.save
      flash[:info] = "フォルダーを登録しました"
    else
      flash[:info] = "フォルダーの登録に失敗しました"
    end
    redirect_to "/users/#{session[:user_id]}" and return
  end

  # PATCH /users/:user_id/folders/:folder_id
  def update
    if @folder.update(folder_params)
      flash[:info] = "フォルダーを変更しました"
    else
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

  # GET /users/:user_id/folders/sort/:folder_sort_ids
  def sort
    ActiveRecord::Base.transaction do
      folder_ids = params[:folder_sort_ids].split(",");
      folder_ids.each_with_index do |folder_id, i|
        folder = Folder.find(folder_id);
        if !login_user?(folder.user_id)
          # ログインユーザが管轄するフォルダー以外を変更しようとしているため、エラー
          raise RuntimeError.new();
        end
        folder.sort = i;
        folder.save
      end
      flash[:info] = "フォルダーのソートが完了しました"
    end
    redirect_to "/users/#{session[:user_id]}" and return
  rescue => e
    logger.debug(e.message);
    flash[:error] = "フォルダーのソートに失敗しました"
    redirect_to "/users/#{session[:user_id]}" and return
  end

  # GET /users/:user_id/folders/:folder_id/links/like
  def like
    @like = Like.find_by(user_id: session[:user_id], folder_id: @folder.id)
    if @like
      # 存在した場合はいいね！取り消し
      @like.destroy
      response = {info_message: "いいね！を取り消しました", like_count: Like.where(folder_id: @folder.id).count, liked: false}
      render :json => response
    else
      # 存在しない場合はいいね！
      @like = Like.new()
      @like.user_id = session[:user_id]
      @like.folder_id = @folder.id
      @like.save
      response = {info_message: "いいね！しました", like_count: Like.where(folder_id: @folder.id).count, liked: true}
      render :json => response
    end
  end

  protected
    # フォルダーいいねチェック
    def folder_liked?(user_id, folder_id)
      @like = Like.find_by(user_id: user_id, folder_id: folder_id)
      if @like
        return true
      else
        return false
      end
    end

  private
    def folder_params
      params.require(:folder).permit(:name, :comment, :is_open)
    end
end
