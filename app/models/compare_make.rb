class CompareMake < ActiveRecord::Base
	belongs_to :make
  belongs_to :website
   
  validates :website_id, :make_id, :value, :presence => true
end
