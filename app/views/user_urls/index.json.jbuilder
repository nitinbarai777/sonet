json.array!(@o_all) do |o_row|
  json.extract! o_row, :url_name, :created_at
  json.url user_url(o_row, format: :json)
end
