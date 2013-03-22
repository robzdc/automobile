class Make < ActiveRecord::Base
  attr_accessible :name
  
  has_many :websites
  
  validates :name, :uniqueness => true
end
