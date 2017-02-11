require 'rss'
require 'open-uri'


module LedBadge
  
  class Feed
    
    def self.items(url = 'http://feeds.bbci.co.uk/news/rss.xml', opts = {})
      open(url) do |rss|
        feed = RSS::Parser.parse(rss)
        return feed.items[0..opts[:num] || 6].collect {|item| {message: item.title, options: {}} }
      end
    end
    
  end
  
end