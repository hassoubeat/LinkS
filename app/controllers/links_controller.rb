class LinksController < ApplicationController
  before_action :login_user_check, only: [:create]

  # POST /users/:user_id/folders/:folder_id/links
  def create
    @link = Link.new(link_params)
    @link.is_valid = true
    @link.user_id = session[:user_id]
    @link.folder_id = params[:folder_id]

    # フォルダー名が入力されていない時は、デフォルト名で登録する
    if @link.name == ""
      @link.name = LINK_DEFAULT_NAME
    end

    if @link.save
      flash[:info] = "ブックマークを登録しました"
    else
      # TODO システムエラー
      flash[:info] = "ブックマークの登録に失敗しました"
    end
    redirect_to "/users/#{session[:user_id]}/folders/#{params[:folder_id]}" and return
  end

  private
    def link_params
      params.require(:link).permit(:name, :url, :comment, :skin_type)
    end
end
