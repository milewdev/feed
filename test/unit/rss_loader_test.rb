require 'test_helper'

describe 'RssLoader#load' do
  it 'deletes existing channel records' do
    existing_channel = Channel.create()
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    Channel.exists?(existing_channel.id).must_equal false
  end

  it 'loads all channel fields' do
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    expected = test_data.channel
    actual = Channel.all.first
    # TODO: extract helper equals method?
    expected.title.must_equal           actual.title
    expected.link.must_equal            actual.link
    expected.description.must_equal     actual.description
    expected.lastBuildDate.must_equal   actual.last_build_date
    expected.language.must_equal        actual.language
    expected.generator.must_equal       actual.generator
  end

  it 'deletes existing item records' do
    existing_channel = Channel.create()
    existing_item = existing_channel.items.create()
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    Item.exists?(existing_item.id).must_equal false
  end

  it 'loads all item fields for all items' do
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    loaded_item = Item.all.first
    test_item = test_data.items.first
    test_data.items.zip(Item.all).each do |expected, actual|
      # TODO: extract helper equals method?
      expected.title.must_equal        actual.title
      expected.link.must_equal         actual.link
      expected.comments.must_equal     actual.comments
      expected.pubDate.must_equal      actual.pub_date
      expected.guid.to_s.must_equal    actual.guid
      expected.description.must_equal  actual.description
    end
  end
end


#
# Test support functions and data.
#
require 'rss'

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
