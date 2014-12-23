require 'rss'
require 'open-uri'

class RssLoader
    def load

      purge_existing_data()

      url = 'http://www.macleans.ca/multimedia/feed/'
      open(url) do |rss_io|
        rss_data = RSS::Parser.parse(rss_io)
        channel = create_channel(rss_data.channel)
        create_items(channel, rss_data.items)
      end

    end

  private

    def purge_existing_data
      Channel.destroy_all
    end

    def create_channel(rss_channel)
      Channel.create(
        title:            rss_channel.title,
        link:             rss_channel.link,
        description:      rss_channel.description,
        last_build_date:  rss_channel.lastBuildDate,
        language:         rss_channel.language,
        generator:        rss_channel.generator
      )
    end

    def create_items(channel, rss_items)
      rss_items.each { |rss_item| create_item(channel, rss_item) }
    end

    def create_item(channel, rss_item)
      channel.items.create(
        title:            rss_item.title,
        link:             rss_item.link,
        comments:         rss_item.comments,
        pub_date:         rss_item.pubDate,
        guid:             rss_item.guid.to_s,
        description:      rss_item.description
      )
    end

end
