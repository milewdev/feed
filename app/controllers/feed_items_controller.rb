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

  # POST /feed_items
  # POST /feed_items.json
  def create
    @feed_item = FeedItem.new(feed_item_params)

    if @feed_item.save
      render json: @feed_item, status: :created, location: @feed_item
    else
      render json: @feed_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /feed_items/1
  # PATCH/PUT /feed_items/1.json
  def update
    @feed_item = FeedItem.find(params[:id])

    if @feed_item.update(feed_item_params)
      head :no_content
    else
      render json: @feed_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /feed_items/1
  # DELETE /feed_items/1.json
  def destroy
    @feed_item = FeedItem.find(params[:id])
    @feed_item.destroy

    head :no_content
  end

  private
    
    def feed_item_params
      params.require(:feed_item).permit(:title, :guid)
    end
end
