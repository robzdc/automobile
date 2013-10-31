class CompareModel < ActiveRecord::Base
	has_many :models
  has_many :websites
  
  validates :website_id, :model_id, :value, :presence => true
end
