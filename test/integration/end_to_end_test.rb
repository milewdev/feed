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

  def assert_data_equal(rss, json)
    rss_channel, json_channel = parse(rss).channel, json.first
    assert_channel_equal rss_channel, json_channel
    assert_items_equal rss_channel.items, json_channel['items']
  end

  def assert_channel_equal(rss_channel, json_channel)
    assert_match %r{/v[0-9]+/channels/[0-9]+\.json},      json_channel['href']
    assert_equal rss_channel.title,                       json_channel['title']
    assert_equal rss_channel.link,                        json_channel['link']
    assert_equal rss_channel.description,                 json_channel['description']
    assert_equal to_json_date(rss_channel.lastBuildDate), json_channel['lastBuildDate']
    assert_equal rss_channel.language,                    json_channel['language']
    assert_equal rss_channel.generator,                   json_channel['generator']
  end

  def assert_items_equal(rss_items, json_items)
    sorted_from_rss = sort_rss_items(rss_items)
    sorted_from_json = sort_json_items(json_items)
    rss_items.zip(json_items).each do |rss_item, json_item|
      assert_item_equal(rss_item, json_item)
    end
  end

  def sort_rss_items(items)
    items.sort { |a, b| a.title <=> b.title }
  end

  def sort_json_items(items)
    items.sort { |a, b| a['title'] <=> b['title'] }
  end

  def assert_item_equal(rss_item, json_item)
    assert_equal rss_item.title,       json_item['title']
    assert_equal rss_item.link,        json_item['link']
    assert_equal rss_item.comments,    json_item['comments']
    assert_equal rss_item.pubDate,     json_item['pubDate']
    assert_equal rss_item.guid.to_s,   json_item['guid']
    assert_equal rss_item.description, json_item['description']
  end
end
