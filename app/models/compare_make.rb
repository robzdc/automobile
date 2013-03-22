class CompareMake < ActiveRecord::Base
  attr_accessible :make_id,:website_id,:value
  
  belongs_to :make
  belongs_to :website
  
  validates :website_id, :make_id, :value, :presence => true
end
