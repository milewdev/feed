class V2::ChannelsController < ApplicationController
  # GET /v2/channels
  # GET /v2/channels.json
  def index
    @channels = Channel.all

    render json: @channels
  end

  # GET /v2/channels/1
  # GET /v2/channels/1.json
  def show
    @channel = Channel.find(params[:id])

    render json: @channel
  end
end
