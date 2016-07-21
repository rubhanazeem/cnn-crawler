class DashboardController < ApplicationController
  def welcome
    Article.fetch_new_articles
    @new_articles = Article.all
  end
end
