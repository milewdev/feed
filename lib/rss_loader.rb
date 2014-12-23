require 'rss'
require 'open-uri'

class RssLoader
    def load

      purge_existing_data()

      url = 'http://www.macleans.ca/multimedia/feed/'
      open(url) do |rss_io|
        rss_data = RSS::Parser.parse(rss_io)
        channel = create_channel(rss_data)

        rss_data.items.each do |rss_item|
          create_item(channel, rss_item)
        end

      end

    end

  private

    def purge_existing_data
      Channel.destroy_all
    end

    def create_channel(rss_data)
      Channel.create(
        title:            rss_data.channel.title,
        link:             rss_data.channel.link,
        description:      rss_data.channel.description,
        last_build_date:  rss_data.channel.lastBuildDate,
        language:         rss_data.channel.language,
        generator:        rss_data.channel.generator
      )
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
