require 'test_helper'

class V1ApiConformanceTest < ActionDispatch::IntegrationTest
  def test_expected_normal_behaviour
    load_db_with_test_data
    actual_json = get_json_from('/v1/feed_items')
    assert_equal expected_json, actual_json
  end

  def test_no_data
    clear_db
    actual_json = get_json_from('/v1/feed_items')
    assert_equal expected_json, actual_json
  end
end

#
# Test support functions and data.
#
class V1ApiConformanceTest
  private

  def clear_db
    FeedItem.delete_all
  end

  def load_db_with_test_data
    clear_db
    FeedItem.create( 
      id: 1,
      title: 'title1',
      guid: 'guid1',
      created_at: '2014-12-29T08:43:27.000Z',
      updated_at: '2014-12-29T08:43:27.001Z'
    )
    FeedItem.create( 
      id: 2,
      title: 'title2',
      guid: 'guid2',
      created_at: '2014-12-29T08:43:27.002Z',
      updated_at: '2014-12-29T08:43:27.003Z'
    )
  end

  def expected_json
    hash_of_db_data = FeedItem.all.map do |item|
      {
        id: item.id,
        title: item.title,
        guid: item.guid,
        created_at: to_json_date(item.created_at),
        updated_at: to_json_date(item.updated_at)
      }
    end
    JSON.generate(hash_of_db_data)
  end

  def get_json_from(url)
    get url
    response.body
  end

  # 2012-04-23T18:25:43.511Z
  # See http://stackoverflow.com/a/15952652
  # TODO: duplicated in end_to_end_test.rb; extract to helper library
  def to_json_date(date)
    date.utc.strftime('%FT%T.%LZ')
  end
end
