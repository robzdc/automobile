class Model < ActiveRecord::Base
  attr_accessible :make_id, :name
  
  belongs_to :make
  has_many :compare_models
 
  
end
