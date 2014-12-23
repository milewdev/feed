json.array!(@channels) do |channel|

  json.extract! channel, :title, :link, :description
  json.lastBuildDate channel.last_build_date
  json.extract! channel, :language, :generator

  # TODO: make it RESTful?  i.e. add links
  # json.url channel_url(channel, format: :json)
  json.items channel.items do |item|
    json.extract! item, :title, :link, :comments
    json.pubDate item.pub_date
    json.extract! item, :guid, :description
  end

end
