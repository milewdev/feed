require 'test_helper'

class V1ApiConformanceTest < ActionDispatch::IntegrationTest
  def test_expected_normal_behaviour
    load_db_with_test_data
    actual_json = call_v1_api
    assert_equal expected_json, actual_json
  end

  def test_no_data
    clear_db
    actual_json = call_v1_api
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

  def call_v1_api
    get '/v1/feed_items'
    response.body
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
end
