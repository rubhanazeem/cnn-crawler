class DashboardController < ApplicationController
  def welcome
    # Article.fetch_new_articles
    @new_articles = Article.all
    @articles = Article.where('tag= ? OR tag= ?', 'Clinton', 'both')
  end

  def refresh
    Article.fetch_new_articles
    @new_articles = Article.all
    render template: "welcome"
  end

  def clinton

  end
end
