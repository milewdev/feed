class V1::FeedItemsController < ApplicationController
  # GET /v1/feed_items
  # GET /v1/feed_items.json
  def index
    @feed_items = Item.all

    # render json: @feed_items
    render template: 'v1/feed_items/index.json.jbuilder'
  end

  # GET /v1/feed_items/1
  # GET /v1/feed_items/1.json
  def show
    @feed_item = Item.find(params[:id])

    render json: @feed_item
  end
end
