require 'test_helper'


class EndToEndTest < ActionDispatch::IntegrationTest

  def test_that_feeder_caches_an_RSS_feed_and_provides_a_JSON_refeed
    run_rss_loader_with(rss)
    json = get_json_from('/v2/channels')
    assert_data_equal(rss, json)
  end

end


#
# Test support functions and data.
#
class EndToEndTest

  private

  def rss
    <<-EOS
      <rss
        xmlns:content="http://purl.org/rss/1.0/modules/content/"
        xmlns:wfw="http://wellformedweb.org/CommentAPI/"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:atom="http://www.w3.org/2005/Atom"
        xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
        xmlns:slash="http://purl.org/rss/1.0/modules/slash/" version="2.0">

        <channel>
          <title>title</title>
          <link>link</link>
          <description>description</description>
          <lastBuildDate>Sat, 2 Feb 2014 12:34:56 +0000</lastBuildDate>
          <language>language</language>
          <generator>generator</generator>

          <item>
            <title>item_title</title>
            <link>item_link</link>
            <comments>item_comments</comments>
            <pubDate>Sat, 3 Mar 2014 12:34:56 +0000</pubDate>
            <guid isPermaLink="false">item_guid</guid>
            <description>item_description</description>
          </item>

          <item>
            <title>item_title_2</title>
            <link>item_link_2</link>
            <comments>item_comments_2</comments>
            <pubDate>Sat, 3 Mar 2014 12:34:57 +0000</pubDate>
            <guid isPermaLink="false">item_guid_2</guid>
            <description>item_description_2</description>
          </item>
        </channel>
      </rss>
    EOS
  end

  def parse(rss)
    RSS::Parser.parse(rss)
  end

  def run_rss_loader_with(rss)
    loader = create_loader_that_loads(rss)
    loader.load
  end

  def get_json_from(url)
    get url
    JSON.parse(response.body)
  end

  def assert_data_equal(rss, json_data)
    channel_from_rss, channel_from_json = parse(rss).channel, json_data.first
    assert_channel_equal(channel_from_rss, channel_from_json)

    items_from_rss, items_from_json = parse(rss).channel.items, json_data.first['items']
    assert_items_equal(items_from_rss, items_from_json)
  end

  def assert_channel_equal(channel_from_rss, channel_from_json)
    assert_match %r{/v[0-9]+/channels/[0-9]+\.json}, channel_from_json['href']
    assert_equal channel_from_rss.title, channel_from_json['title']
    assert_equal channel_from_rss.link, channel_from_json['link']
    assert_equal channel_from_rss.description, channel_from_json['description']
    assert_equal to_json_date(channel_from_rss.lastBuildDate), channel_from_json['lastBuildDate']
    assert_equal channel_from_rss.language, channel_from_json['language']
    assert_equal channel_from_rss.generator, channel_from_json['generator']
  end

  def assert_items_equal(items_from_rss, items_from_json)
    sorted_from_rss = sort_items_from_rss(items_from_rss)
    sorted_from_json = sort_items_from_json(items_from_json)
    items_from_rss.zip(items_from_json).each do |item_from_rss, item_from_json|
      assert_item_equal(item_from_rss, item_from_json)
    end
  end

  def sort_items_from_rss(items)
    items.sort { |a, b| a.title <=> b.title }
  end

  def sort_items_from_json(items)
    items.sort { |a, b| a['title'] <=> b['title'] }
  end

  def assert_item_equal(item_from_rss, item_from_json)
    assert_equal item_from_rss.title,       item_from_json['title']
    assert_equal item_from_rss.link,        item_from_json['link']
    assert_equal item_from_rss.comments,    item_from_json['comments']
    assert_equal item_from_rss.pubDate,     item_from_json['pubDate']
    assert_equal item_from_rss.guid.to_s,   item_from_json['guid']
    assert_equal item_from_rss.description, item_from_json['description']
  end

  # 2012-04-23T18:25:43.511Z
  # See http://stackoverflow.com/a/15952652
  def to_json_date(date)
    date.utc.strftime('%FT%T.%LZ')
  end

end
