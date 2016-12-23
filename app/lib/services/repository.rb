require 'models/article'

module Services
  class Repository
    def initialize(data_mapper)
      @data_mapper = data_mapper
      @articles = @data_mapper.articles
    end

    def available_years
      @articles.map(&:year)
    end

    def all_articles
      @articles
    end

    def update_article(year, patch_changes)
      @data_mapper.update year, patch_changes
    end

    def add_item(year, item)
      article = by_year year
      @data_mapper.add article, item
    end

    def by_year(year)
      found_article = @articles.find { |article| article.year.to_s == year }
      if found_article.nil?
        Model::Article.new year
      else
        found_article
      end
    end

    def size
      @articles.size
    end
  end
end
