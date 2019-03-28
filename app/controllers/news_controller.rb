class NewsController < ApplicationController
  layout "management"
  before_action :admin_check_filter
  before_action :set_news, only: [:edit, :update, :destroy]

  # GET /management/news
  def index
    @newses = News.all.is_valid
  end

  # GET /management/news/new
  def new
    @news = News.new
  end

  # POST /management/news
  def create
    @news = News.new(news_params)
    @news.user_id = @current_user.id
    @news.is_valid = true;
    if @news.save
      flash[:info] = "ニュースを登録しました"
    else
      flash[:info] = "ニュースの登録に失敗しました"
    end
    redirect_to "/management/news" and return
  end

  # GET /management/news/edit/:news_id
  def edit
  end

  # PATCH /management/news/:news_id
  def update
    if @news.update(news_params)
      flash[:info] = "ニュースを更新しました"
    else
      flash[:info] = "ニュースの更新に失敗しました"
    end
    redirect_to "/management/news" and return
  end

  # DELETE /management/news/:news_id
  def destroy
    @news.is_valid = false;
    if @news.save
      flash[:info] = "ニュースを削除しました"
    else
      flash[:info] = "ニュースの削除に失敗しました"
    end
    redirect_to "/management/news" and return
  end

  private

    def set_news
      @news = News.find(params[:news_id])
    end

    def news_params
      params.require(:news).permit(:title, :content, :is_open)
    end
end
