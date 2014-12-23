require 'rss'
require 'open-uri'

class RssLoader
    def load

      purge_existing_data()

      url = 'http://www.macleans.ca/multimedia/feed/'
      open(url) do |rss_io|
        rss_data = RSS::Parser.parse(rss_io)
        channel = Channel.create(
          title:            rss_data.channel.title,
          link:             rss_data.channel.link,
          description:      rss_data.channel.description,
          last_build_date:  rss_data.channel.lastBuildDate,
          language:         rss_data.channel.language,
          generator:        rss_data.channel.generator
        )

        rss_data.items.each do |item|
          channel.items.create(
            title:          item.title,
            link:           item.link,
            comments:       item.comments,
            pub_date:       item.pubDate,
            guid:           item.guid.to_s,
            description:    item.description
          )
        end

      end

    end

  private

    def purge_existing_data
      Channel.destroy_all
    end

end
