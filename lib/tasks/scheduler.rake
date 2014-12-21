# See https://devcenter.heroku.com/articles/scheduler

namespace :feed_items do
  desc 'Update the db with current feed items (should be run once per hour)'
  task :update => :environment do
    puts 'Update feed items start'

    require 'rss'
    require 'open-uri'
    url = 'http://www.macleans.ca/multimedia/feed/'

    num_affected = 0
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      num_affected = feed.items.length
      feed.items.each do |item|
        feed_item = FeedItem.find_or_initialize_by(guid: item.guid)
        feed_item.update(title: item.title)
      end
    end

    puts "Update feed items done: added or updated #{num_affected} feed item(s)"
  end

  desc 'Purge feed items from the db older than seven days old (should be run once per day)'
  task :purge_old => :environment do
    puts 'Purge old feed items start'
    # Purge items that haven't appeared in the source feed for at least seven
    # days.  update_at will only be updated when an item is in the feed.
    num_deleted = FeedItem.where('updated_at < ?', 7.days.ago).destroy_all.length
    puts "Purge old feed items done: deleted #{num_deleted} feed item(s)"
  end
end
