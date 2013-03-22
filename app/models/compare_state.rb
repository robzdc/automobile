class CompareState < ActiveRecord::Base
  attr_accessible :state_id, :value, :website_id
  
  has_many :states
  has_many :websites
end
