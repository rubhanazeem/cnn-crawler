class Article < ActiveRecord::Base
  validates :title, uniqueness: true
  require 'open-uri'

  def self.fetch_new_articles()
    Article.destroy_all
    url = "http://us.cnn.com/specials/politics/2016-election"
    # http://us.cnn.com/specials/politics/world-politics
    doc = Nokogiri::HTML(open(url))
    count = 0
    to_check = Array.new
    doc.css("article").each do |item|
      count_clinton = Article.where('tag= ? OR tag= ?', 'Clinton', 'both').count
      count_trump = Article.where('tag= ? OR tag= ?', 'Trump', 'both').count
      title = item.at_css(".cd__headline-text").text
      href = "http://us.cnn.com/"+item.at_css("a").attr('href')
      image = item.at_css("img").attr('data-src-medium').to_s rescue nil
      if ((title.include?("Hillary Clinton") || title.include?("Clinton")) && (title.include?("Donald Trump") || title.include?("Trump"))) && (count_clinton < 25 && count_trump < 25)
        if image != nil
          Article.create(title: title, url: href, image: image, tag: "both")
        else
          Article.create(title: title, url: href, image: nil, tag: "both")
        end
      elsif (title.include?("Hillary Clinton") || title.include?("Clinton")) && (count_clinton < 25)
        if image != nil
          Article.create(title: title, url: href, image: image, tag: "Clinton")
        else
          Article.create(title: title, url: href, image: nil, tag: "clinton")
        end
      elsif (title.include?("Donald Trump") || title.include?("Trump")) && (count_trump < 25)
        if image != nil
          Article.create(title: title, url: href, image: image, tag: "Trump")
        else
          Article.create(title: title, url: href, image: nil, tag: "Trump")
        end
      else
        record = [href, title, image]
        to_check << record
      end
      # image = item.at_css("img").attr('data-src-medium')
      # general = item.at_css(".cd__headline-text , .media__image--responsive").text
      # http://us.cnn.com/
    end
    Article.check_article(to_check)
  end

  def self.check_article(records)
    records.each do |record|
      count_clinton = Article.where('tag= ? OR tag= ?', 'Clinton', 'both').count
      count_trump = Article.where('tag= ? OR tag= ?', 'Trump', 'both').count
      if count_clinton < 25 || count_trump < 25
        article = Nokogiri::HTML(open(record[0]))
        article.css("li:nth-child(10) , .cnn_rich_text li:nth-child(1) , div.zn-body__paragraph , .el-editorial-note , #body-text li:nth-child(3) , li:nth-child(9) , li:nth-child(8) , li:nth-child(7) , li:nth-child(6) , li:nth-child(5) , .el__factbox--title , .el__headline , .el__leafmedia--sourced-paragraph .zn-body__paragraph").each do |art|
          # if text is nil, means no article available. There must me a video
          text = art.text rescue nil
          if ((text.include?("Hillary Clinton") || text.include?("Clinton")) && (text.include?("Donald Trump") || text.include?("Trump"))) && (count_clinton < 25 && count_trump < 25)
            Article.create(title: record[1], url: record[0], image: record[2], tag: "both")
          elsif (text.include?("Hillary Clinton") || text.include?("Clinton")) && (count_clinton < 25)
            Article.create(title: record[1], url: record[0], image: record[2], tag: "Clinton")
          elsif (text.include?("Donald Trump") || text.include?("Trump")) && (count_trump < 25)
            Article.create(title: record[1], url: record[0], image: record[2], tag: "Trump")
          end
        end
      end
    end
  end
end
