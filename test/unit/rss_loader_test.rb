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
    rss_channel, db_channel = test_data.channel, Channel.all.first
    assert_channel_equal(rss_channel, db_channel)
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
    rss_items, db_items = test_data.items, Item.all
    assert_items_equal(rss_items, db_items)
  end
end


#
# Test support functions and data.
# TODO: move inside outer describe block so that they are not globally visible.
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

def assert_channel_equal(rss_channel, db_channel)
  rss_channel.title.must_equal           db_channel.title
  rss_channel.link.must_equal            db_channel.link
  rss_channel.description.must_equal     db_channel.description
  rss_channel.lastBuildDate.must_equal   db_channel.last_build_date
  rss_channel.language.must_equal        db_channel.language
  rss_channel.generator.must_equal       db_channel.generator
end

# Note that we sort the items so that we compare item 1 from RSS
# with item 1 from the db, etc.
def assert_items_equal(rss_items, db_items)
  rss_sorted = sort_items(rss_items)
  db_sorted = sort_items(db_items)
  rss_sorted.zip(db_sorted).each do |rss_item, db_item|
    assert_item_equal(rss_item, db_item)
  end
end

def sort_items(items)
  items.sort { |a, b| a.title <=> b.title }
end

def assert_item_equal(rss_item, db_item)
  rss_item.title.must_equal        db_item.title
  rss_item.link.must_equal         db_item.link
  rss_item.comments.must_equal     db_item.comments
  rss_item.pubDate.must_equal      db_item.pub_date
  rss_item.guid.to_s.must_equal    db_item.guid
  rss_item.description.must_equal  db_item.description
end
