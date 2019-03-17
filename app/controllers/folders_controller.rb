class FoldersController < ApplicationController
  skip_before_action :login_check, only: [:new, :create, :user_check, :login]
  before_action :set_folder, only: [:show, :edit, :update, :destroy]
  before_action :login_user_check, only: [:create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/:user_id/folders/:folder_id
  def show
  end

  # GET /users/:user_id/folders/new
  def new
  end

  # GET /users/:user_id/folders/edit
  def edit
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def folder_params
      params.require(:folder).permit(:name, :comment, :is_open)
    end
end
