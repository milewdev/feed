require 'rss'
require 'open-uri'

class RssLoader
  def load

    Channel.destroy_all

    url = 'http://www.macleans.ca/multimedia/feed/'
    open(url) do |rss_io|
      rss_data = RSS::Parser.parse(rss_io)
      Channel.create(
        title: rss_data.channel.title,
        link: rss_data.channel.link,
        description: rss_data.channel.description,
        lastBuildDate: rss_data.channel.lastBuildDate,
        language: rss_data.channel.language,
        generator: rss_data.channel.generator
      )
    end

  end
end
