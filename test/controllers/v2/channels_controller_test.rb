require 'test_helper'

class V2::ChannelsControllerTest < ActionController::TestCase
  setup do
    @channel = channels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:channels)
  end

  test "should show channel" do
    get :show, id: @channel
    assert_response :success
  end
end
