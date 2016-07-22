class DashboardController < ApplicationController
  def welcome
    # Article.fetch_new_articles
    @new_articles = Article.all
    @articles_hillary = Article.where('tag= ?', 'Clinton')
    @articles_trump = Article.where('tag= ?', 'Trump')
  end

  def refresh
    Article.fetch_new_articles
    redirect_to root_url
  end

  def clinton

  end
end
