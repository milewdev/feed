require 'test_helper'

class V2::ChannelsControllerTest < ActionController::TestCase
  setup do
    @v2_channel = v2_channels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:v2_channels)
  end

  test "should create v2_channel" do
    assert_difference('V2::Channel.count') do
      post :create, v2_channel: { description: @v2_channel.description, generator: @v2_channel.generator, language: @v2_channel.language, lastBuildDate: @v2_channel.lastBuildDate, link: @v2_channel.link, title: @v2_channel.title }
    end

    assert_response 201
  end

  test "should show v2_channel" do
    get :show, id: @v2_channel
    assert_response :success
  end

  test "should update v2_channel" do
    put :update, id: @v2_channel, v2_channel: { description: @v2_channel.description, generator: @v2_channel.generator, language: @v2_channel.language, lastBuildDate: @v2_channel.lastBuildDate, link: @v2_channel.link, title: @v2_channel.title }
    assert_response 204
  end

  test "should destroy v2_channel" do
    assert_difference('V2::Channel.count', -1) do
      delete :destroy, id: @v2_channel
    end

    assert_response 204
  end
end
