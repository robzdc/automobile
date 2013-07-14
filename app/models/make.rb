class Make < ActiveRecord::Base
  attr_accessible :name
  
  has_many :websites
  has_many :models
  
  validates :name, :uniqueness => true
end
