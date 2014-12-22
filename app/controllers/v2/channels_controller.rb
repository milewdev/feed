class V2::ChannelsController < ApplicationController
  # GET /v2/channels
  # GET /v2/channels.json
  def index
    @v2_channels = V2::Channel.all

    render json: @v2_channels
  end

  # GET /v2/channels/1
  # GET /v2/channels/1.json
  def show
    @v2_channel = V2::Channel.find(params[:id])

    render json: @v2_channel
  end

  # POST /v2/channels
  # POST /v2/channels.json
  def create
    @v2_channel = V2::Channel.new(v2_channel_params)

    if @v2_channel.save
      render json: @v2_channel, status: :created, location: @v2_channel
    else
      render json: @v2_channel.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /v2/channels/1
  # PATCH/PUT /v2/channels/1.json
  def update
    @v2_channel = V2::Channel.find(params[:id])

    if @v2_channel.update(v2_channel_params)
      head :no_content
    else
      render json: @v2_channel.errors, status: :unprocessable_entity
    end
  end

  # DELETE /v2/channels/1
  # DELETE /v2/channels/1.json
  def destroy
    @v2_channel = V2::Channel.find(params[:id])
    @v2_channel.destroy

    head :no_content
  end

  private
    
    def v2_channel_params
      params.require(:v2_channel).permit(:title, :link, :description, :lastBuildDate, :language, :generator)
    end
end
