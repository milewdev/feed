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
    assert_channel_equal(test_data.channel, Channel.all.first)
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
    assert_items_equal(test_data.items, Item.all)
  end
end


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

def assert_channel_equal(channel_from_rss, channel_from_db)
  channel_from_rss.title.must_equal           channel_from_db.title
  channel_from_rss.link.must_equal            channel_from_db.link
  channel_from_rss.description.must_equal     channel_from_db.description
  channel_from_rss.lastBuildDate.must_equal   channel_from_db.last_build_date
  channel_from_rss.language.must_equal        channel_from_db.language
  channel_from_rss.generator.must_equal       channel_from_db.generator
end

def assert_items_equal(items_from_rss, items_from_db)
  items_from_rss.zip(items_from_db).each do |item_from_rss, item_from_db|
    assert_item_equal(item_from_rss, item_from_db)
  end
end

def assert_item_equal(item_from_rss, item_from_db)
  item_from_rss.title.must_equal        item_from_db.title
  item_from_rss.link.must_equal         item_from_db.link
  item_from_rss.comments.must_equal     item_from_db.comments
  item_from_rss.pubDate.must_equal      item_from_db.pub_date
  item_from_rss.guid.to_s.must_equal    item_from_db.guid
  item_from_rss.description.must_equal  item_from_db.description
end
