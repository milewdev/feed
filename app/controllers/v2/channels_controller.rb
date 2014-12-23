class V2::ChannelsController < ApplicationController
  # GET /v2/channels
  # GET /v2/channels.json
  def index
    @channels = Channel.all

    render template: 'v2/channels/index.json.jbuilder'
  end

  # GET /v2/channels/1
  # GET /v2/channels/1.json
  def show
    @channel = Channel.find(params[:id])

    # TODO: use a template
    render json: @channel
  end
end
