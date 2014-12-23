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
    loaded_channel.title.must_equal           test_data.channel.title
    loaded_channel.link.must_equal            test_data.channel.link
    loaded_channel.description.must_equal     test_data.channel.description
    loaded_channel.last_build_date.must_equal test_data.channel.lastBuildDate
    loaded_channel.language.must_equal        test_data.channel.language
    loaded_channel.generator.must_equal       test_data.channel.generator
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
