require 'test_helper'

class FeedItemsTest < ActionDispatch::IntegrationTest

  describe 'GET /feed_items' do
    it 'returns all of the feed items' do
      get "/feed_items", {}, { "Accept" => "application/json" }
      # xhr :get, "/movies"
      # expect(response.status).to eq 200
    end
  end

end
