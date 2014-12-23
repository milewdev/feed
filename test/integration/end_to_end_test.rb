require 'test_helper'

class EndToEndTest < ActionDispatch::IntegrationTest

  # TODO: refactor
  test 'feeder caches an RSS feed and provides a JSON refeed' do
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    get '/v2/channels'
    json = JSON.parse(response.body)

    expected = test_data.channel
    actual = json.first
    # TODO: put expected on the left (or the right?  how is the error reported?)
    # TODO: use an assertion that reports the two differing values
    assert_match %r{/v[0-9]+/channels/[0-9]+\.json}, actual['href']
    assert actual['title'] == expected.title
    assert actual['link'] == expected.link
    assert actual['description'] == expected.description

    # TODO: extract helper method
    # 2012-04-23T18:25:43.511Z
    # See http://stackoverflow.com/a/15952652
    assert actual['lastBuildDate'] == expected.lastBuildDate.utc.strftime('%FT%T.%LZ')

    assert actual['language'] == expected.language
    assert actual['generator'] == expected.generator

    test_data.channel.items.zip(json.first['items']).each do |expected, actual|
      assert expected.title == actual['title']
      assert expected.link == actual['link']
      assert expected.comments == actual['comments']
      assert expected.pubDate == actual['pubDate']
      assert expected.guid.to_s == actual['guid']
      assert expected.description == actual['description']
    end
  end

  private

  #
  # Test support functions and data.
  #
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

end
