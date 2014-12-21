class FeedItemsController < ApplicationController
  # GET /feed_items
  # GET /feed_items.json
  def index
    @feed_items = FeedItem.all

    render json: @feed_items
  end

  # GET /feed_items/1
  # GET /feed_items/1.json
  def show
    @feed_item = FeedItem.find(params[:id])

    render json: @feed_item
  end
end
