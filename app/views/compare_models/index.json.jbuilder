json.array!(@compare_models) do |compare_model|
  json.extract! compare_model, :model_id, :website_id, :value
  json.url compare_model_url(compare_model, format: :json)
end
