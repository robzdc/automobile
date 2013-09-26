class Country < ActiveRecord::Base
  attr_accessible :name,:active
  
  has_many :states
end
