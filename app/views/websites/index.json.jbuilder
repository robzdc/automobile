json.array!(@websites) do |website|
  json.extract! website, :url
  json.url website_url(website, format: :json)
end
