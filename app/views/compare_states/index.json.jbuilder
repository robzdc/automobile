json.array!(@compare_states) do |compare_state|
  json.extract! compare_state, :state_id, :website_id, :value
  json.url compare_state_url(compare_state, format: :json)
end
