require 'test_helper'

class V1ApiConformanceTest < ActionDispatch::IntegrationTest
  def test_expected_normal_behaviour
    run_rss_loader_using(rss)
    actual_json = get_json_from('/v1/feed_items')
    assert_match expected_json_regexp, actual_json
  end
end

#
# Test support functions and data.
#
class V1ApiConformanceTest
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

  def expected_json_regexp
    %r{
      \[
        \{
          "id":\d+,
          "title":"test\sarticle\s2",
          "guid":"ta2",
          "created_at":"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z",
          "updated_at":"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z"
        \},
        \{
          "id":\d+,
          "title":"test\sarticle\s1",
          "guid":"ta1",
          "created_at":"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z",
          "updated_at":"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z"
        \}
      \]
    }x
  end

  def run_rss_loader_using(rss)
    loader = create_loader_that_loads(rss)
    loader.load
  end

  def get_json_from(url)
    get url
    response.body
  end
end
