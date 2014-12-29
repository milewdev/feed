json.array!(@feed_items) do |feed_item|
  json.extract! feed_item, :id, :title, :guid, :created_at, :updated_at
end
