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

- The only custom code is a feed:refresh Rake task in lib/tasks/schedule.rake.  The
amount of code is so small that it is all inline within the Rake task itself.  It can
be refactored out if it grows in size.

- The feed:refresh Rake task should be run say once every hour using something
like [cron](http://en.wikipedia.org/wiki/Cron) or [Heroku
Scheduler](https://devcenter.heroku.com/articles/scheduler).
