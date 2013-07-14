class CompareModel < ActiveRecord::Base
  attr_accessible :model_id, :value, :website_id
  
  has_many :models
  has_many :websites
  
  validates :website_id, :model_id, :value, :presence => true
end
