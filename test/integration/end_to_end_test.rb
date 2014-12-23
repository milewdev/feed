require 'test_helper'

class EndToEndTest < ActionDispatch::IntegrationTest

  test 'feeder caches an RSS feed and provides a JSON refeed' do

    # arrange
    loader = create_loader_that_loads test_data_as_rss

    # act
    loader.load
    get '/v2/channels'

    # assert
    json = JSON.parse(response.body)

    channel_from_rss, channel_from_json = test_data.channel, json.first
    assert_channel_equal(channel_from_rss, channel_from_json)

    items_from_rss, items_from_json = test_data.channel.items, json.first['items']
    assert_items_equal(items_from_rss, items_from_json)

  end


  #
  # Test support functions and data.
  #
  private

  def test_data_as_rss
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

  def test_data
    RSS::Parser.parse(test_data_as_rss)
  end

  def assert_channel_equal(channel_from_rss, channel_from_json)
    # TODO: put expected on the left (or the right?  how is the error reported?)
    # TODO: use an assertion that reports the two differing values
    assert_match %r{/v[0-9]+/channels/[0-9]+\.json}, channel_from_json['href']
    assert channel_from_json['title'] == channel_from_rss.title
    assert channel_from_json['link'] == channel_from_rss.link
    assert channel_from_json['description'] == channel_from_rss.description

    # TODO: extract helper method
    # 2012-04-23T18:25:43.511Z
    # See http://stackoverflow.com/a/15952652
    assert channel_from_json['lastBuildDate'] == channel_from_rss.lastBuildDate.utc.strftime('%FT%T.%LZ')

    assert channel_from_json['language'] == channel_from_rss.language
    assert channel_from_json['generator'] == channel_from_rss.generator
  end

  def assert_items_equal(items_from_rss, items_from_json)
    # TODO: need to sort lists before comparing
    items_from_rss.zip(items_from_json).each do |item_from_rss, item_from_json|
      assert_item_equal(item_from_rss, item_from_json)
    end
  end

  def assert_item_equal(item_from_rss, item_from_json)
    assert item_from_rss.title == item_from_json['title']
    assert item_from_rss.link == item_from_json['link']
    assert item_from_rss.comments == item_from_json['comments']
    assert item_from_rss.pubDate == item_from_json['pubDate']
    assert item_from_rss.guid.to_s == item_from_json['guid']
    assert item_from_rss.description == item_from_json['description']
  end

end
