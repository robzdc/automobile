json.array!(@countries) do |country|
  json.extract! country, :name, :active
  json.url country_url(country, format: :json)
end
