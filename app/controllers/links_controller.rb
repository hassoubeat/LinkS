class LinksController < ApplicationController
  before_action :login_id_check_filter, only: [:create, :update, :destroy]

  # POST /users/:user_id/folders/:folder_id/links
  def create
    # 登録上限数のチェック
    links = Link.where(folder_id: @folder.id).is_valid
    if links.count() >= Link::LINK_CREATE_LIMIT
      flash[:error] = "ブックマークの登録上限に達しています"
      redirect_to "/users/#{@current_user.id}/folders/#{params[:folder_id]}" and return
    end

    @link = Link.new(link_params)
    @link.is_valid = true
    @link.sort = Link::LINK_DEFAULT_SORT
    @link.user_id = @current_user.id
    @link.folder_id = params[:folder_id]

    # フォルダー名が入力されていない時は、デフォルト名で登録する
    if @link.name == ""
      @link.name = Link::LINK_DEFAULT_NAME
    end

    if @link.save
      flash[:info] = "ブックマークを登録しました"
    else
      flash[:info] = "ブックマークの登録に失敗しました"
    end
    redirect_to "/users/#{@current_user.id}/folders/#{params[:folder_id]}" and return
  end

  # PATCH /users/:user_id/folders/:folder_id/links/:link_id
  def update
    @link = Link.find(params[:link_id])
    if @link.update(link_params)
      flash[:info] = "リンク : #{@link.name}を変更しました"
    else
      flash[:info] = "リンクの変更に失敗しました"
    end
    redirect_to "/users/#{@current_user.id}/folders/#{params[:folder_id]}}" and return
  end

  # DELETE /users/:user_id/folders/:folder_id/links/:link_id
  def destroy
    @link = Link.find(params[:link_id])
    @link.is_valid = false;
    if @link.save
      flash[:info] = "ブックマーク : #{@link.name}を削除しました"
    else
      flash[:info] = "ブックマークの削除に失敗しました"
    end
    redirect_to "/users/#{@current_user.id}/folders/#{params[:folder_id]}" and return
  end

  # GET /users/:user_id/folders/:folder_id/links/sort/:link_sort_ids
  def sort
    ActiveRecord::Base.transaction do
      link_ids = params[:link_sort_ids].split(",");
      link_ids.each_with_index do |link_id, i|
        link = Link.find(link_id);
        if !login_id_check?(link.user_id)
          # ログインユーザが管轄するリンク以外を変更しようとしているため、エラー
          raise RuntimeError.new();
        end
        link.sort = i;
        link.save
      end
      flash[:info] = "ブックマークのソートが完了しました"
    end
    redirect_to "/users/#{@current_user.id}/folders/#{@folder.id}" and return
  rescue => e
    logger.debug(e.message);
    flash[:error] = "ブックマークのソートに失敗しました"
    redirect_to "/users/#{@current_user.id}/folders/#{@folder.id}" and return
  end

  private
    def link_params
      params.require(:link).permit(:name, :url, :comment, :skin_type)
    end
end
