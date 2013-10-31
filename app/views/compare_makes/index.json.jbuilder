json.array!(@compare_makes) do |compare_make|
  json.extract! compare_make, :make_id, :website_id, :value
  json.url compare_make_url(compare_make, format: :json)
end
