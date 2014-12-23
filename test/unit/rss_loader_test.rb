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
    loaded_channel = Channel.all.first
    test_channel = test_data.channel
    loaded_channel.title.must_equal           test_channel.title
    loaded_channel.link.must_equal            test_channel.link
    loaded_channel.description.must_equal     test_channel.description
    loaded_channel.last_build_date.must_equal test_channel.lastBuildDate
    loaded_channel.language.must_equal        test_channel.language
    loaded_channel.generator.must_equal       test_channel.generator
  end

  it 'deletes existing item records' do
    existing_channel = Channel.create()
    existing_item = existing_channel.items.create()
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    Item.exists?(existing_item.id).must_equal false
  end

  it 'loads all item fields' do
    loader = create_loader_that_loads test_data_as_rss
    loader.load
    loaded_item = Item.all.first
    test_item = test_data.items.first
    loaded_item.title.must_equal        test_item.title
    loaded_item.link.must_equal         test_item.link
    loaded_item.comments.must_equal     test_item.comments
    loaded_item.pub_date.must_equal     test_item.pubDate
    loaded_item.guid.must_equal         test_item.guid.to_s
    loaded_item.description.must_equal  test_item.description
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
      </channel>
    </rss>
  EOS
end

def test_data
  RSS::Parser.parse(test_data_as_rss)
end

def create_loader_that_loads(data_as_rss)
  rss_io = mock()
  rss_io.expects(:read).returns(data_as_rss)
  loader = RssLoader.new
  loader.expects(:open).yields(rss_io)
  loader
end
