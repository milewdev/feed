require 'test_helper'


class RssLoaderTest < Minitest::Test

  def test_that_existing_channel_records_are_deleted
    existing_channel = Channel.create()
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    refute Channel.exists?(existing_channel.id)
  end

  def test_that_all_channel_fields_are_loaded
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    rss_channel, db_channel = test_data.channel, Channel.all.first
    assert_channel_equal rss_channel, db_channel
  end

  def test_that_all_existing_item_records_are_deleted
    existing_channel = Channel.create()
    existing_item = existing_channel.items.create()
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    refute Item.exists?(existing_item.id)
  end

  def test_that_all_item_fields_are_loaded
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    rss_items, db_items = test_data.items, Item.all
    assert_items_equal rss_items, db_items
  end

end


#
# Test support functions and data.
#
class RssLoaderTest

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

  def assert_channel_equal(rss_channel, db_channel)
    assert_equal rss_channel.title,           db_channel.title
    assert_equal rss_channel.link,            db_channel.link
    assert_equal rss_channel.description,     db_channel.description
    assert_equal rss_channel.lastBuildDate,   db_channel.last_build_date
    assert_equal rss_channel.language,        db_channel.language
    assert_equal rss_channel.generator,       db_channel.generator
  end

  # Note that we sort the items so that we compare item 1 from RSS
  # with item 1 from the db, etc.
  def assert_items_equal(rss_items, db_items)
    rss_sorted = sort_items(rss_items)
    db_sorted = sort_items(db_items)
    rss_sorted.zip(db_sorted).each do |rss_item, db_item|
      assert_item_equal rss_item, db_item
    end
  end

  def sort_items(items)
    items.sort { |a, b| a.title <=> b.title }
  end

  def assert_item_equal(rss_item, db_item)
    assert_equal rss_item.title,        db_item.title
    assert_equal rss_item.link,         db_item.link
    assert_equal rss_item.comments,     db_item.comments
    assert_equal rss_item.pubDate,      db_item.pub_date
    assert_equal rss_item.guid.to_s,    db_item.guid
    assert_equal rss_item.description,  db_item.description
  end

end
