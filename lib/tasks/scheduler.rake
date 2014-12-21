# See https://devcenter.heroku.com/articles/scheduler

namespace :feed_items do
  desc 'Update the database with current feed items'
  task :update => :environment do
    puts 'Update feed items start'
    feed_item = FeedItem.find_or_initialize_by(guid: 'a4')
    feed_item.update(title: Time.now.strftime('%Y-%m-%d %H:%M:%S'))
    num_affected = 1
    puts "Update feed items done: added or updated #{num_affected} feed item(s)"
  end

  desc 'Purge feed items from the database that are more than seven days old'
  task :purge_old => :environment do
    puts 'Purge old feed items start'
    num_deleted = FeedItem.where('created_at < ?', 7.days.ago).destroy_all.length
    puts "Purge old feed items done: deleted #{num_deleted} feed item(s)"
  end
end
