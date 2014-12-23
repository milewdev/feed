###What is feed?

feed converts the RSS feed at http://www.macleans.ca/multimedia/feed/ to a json feed.


###Local Installation

```shell
$ git clone https://github.com/milewdev/feed.git ~/work/feed
$ cd ~/work/feed
$ bundle install --without production
$ rbenv rehash
$ rake db:migrate
```


###Usage

```shell
$ cd ~/work/feed
$ rake feed:refresh
$ rails server &
$ curl -w "\n" http://localhost:3000
[{"id":288,"title":...
$ fg
^C
$
```


###Code Notes

- The application was created using [rails-api](https://github.com/rails-api/rails-api)
and therefore serves json responses.

- The feed:refresh (v1) and rss_loader:load (v2) Rake tasks should be run say
once every hour using something like [cron](http://en.wikipedia.org/wiki/Cron)
or [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler).



###Release Notes

####v2.0.1
- Add href to channel JSON data; this provides the direct url of the channel.
- DRY up and refactor test code.

####v2.0.0
- URL is /v2/channels
- Change root shortcut / from /v1/feed_items#index to /v2/channels#index
- Add Channel and Item tables.
- Add RssLoader class responsible for loading RSS feed.
- Add rss_loader:load Rake task responsible for invoking RssLoader.
- Reformat JSON to include channel data and item data as a child of channel.


####v1.0.0
- Initial release.
- URL is /v1/feed_items
- Add root shortcut / to /v1/feed_items#index
