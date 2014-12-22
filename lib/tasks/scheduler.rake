# See https://devcenter.heroku.com/articles/scheduler

namespace :feed_items do

  desc 'Update the db with current feed items'
  task :update => :environment do
    puts 'Update feed items start'

    require 'rss'
    require 'open-uri'
    url = 'http://www.macleans.ca/multimedia/feed/'

    num_added = 0
    num_updated = 0
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        feed_item = FeedItem.where(guid: item.guid.to_s).first_or_initialize
        num_added += 1 if feed_item.id.nil?
        num_updated += 1 unless feed_item.id.nil?
        feed_item.update(title: item.title)
      end
    end

    puts "Update feed items done: added #{num_added} and updated #{num_updated} feed items"
  end

  desc 'Purge feed items from the db older than seven days old'
  task :purge_old => :environment do
    puts 'Purge old feed items start'
    # Purge items that haven't appeared in the source feed for at least seven
    # days.  update_at will only be updated when an item is in the feed.
    num_deleted = FeedItem.where('updated_at < ?', 7.days.ago).destroy_all.length
    puts "Purge old feed items done: deleted #{num_deleted} feed item(s)"
  end

  desc 'Add/update the latest feed items, purge old feed items'
  task :refresh => [:update, :purge_old]

end
