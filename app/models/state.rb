class State < ActiveRecord::Base
  attr_accessible :active, :name,:country_id
  
  belongs_to :country
end
