json.array!(@states) do |state|
  json.extract! state, :name, :active
  json.url state_url(state, format: :json)
end
