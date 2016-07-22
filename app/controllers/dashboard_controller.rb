class DashboardController < ApplicationController
  def welcome
    Article.fetch_new_articles
    @new_articles = Article.all
  end
  def clinton
    @articles = Article.where('tag= ? OR tag= ?', 'Clinton', 'both')
  end
end
