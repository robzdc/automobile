class Make < ActiveRecord::Base
	has_many :websites
  has_many :models
  
  validates :name, :uniqueness => true
end
