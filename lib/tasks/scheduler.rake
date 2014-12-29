# See https://devcenter.heroku.com/articles/scheduler

namespace :rss_loader do
  desc 'Replace the items in the database with the those from the feed'
  task :load => :environment do
    puts '----- rss_loader start -----'
    RssLoader.new.load
    puts '----- rss_loader done -----'
  end
end
