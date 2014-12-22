# See https://devcenter.heroku.com/articles/scheduler

namespace :feed do

  desc 'Replace the items in the database with the those from the feed'
  task :refresh => :environment do
    puts 'Refresh start'

    # Delete all existing records.
    FeedItem.destroy_all

    # Load the latest records from the feed.
    require 'rss'
    require 'open-uri'
    url = 'http://www.macleans.ca/multimedia/feed/'
    num_loaded = 0
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      num_loaded = feed.items.length
      feed.items.each do |item|
        FeedItem.create(guid: item.guid.to_s, title: item.title)
      end
    end

    puts "Refresh done: loaded #{num_loaded} feed item(s)"
  end

end
