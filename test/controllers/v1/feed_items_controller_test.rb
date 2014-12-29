require 'test_helper'

class V1::FeedItemsControllerTest < ActionController::TestCase
  setup do
    @feed_item = items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feed_items)
  end

  test "should show feed_item" do
    get :show, id: @feed_item
    assert_response :success
  end
end
