class NewsController < ApplicationController

  # GET /news
  def index
    @news = News.All()
    render layout: "management"
  end

  # POST /news
  def create
  end
end
