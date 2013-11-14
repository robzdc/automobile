class Make < ActiveRecord::Base
	has_many :websites
  has_many :models
  
  validates :name, uniqueness: { scope: :id,
    message: "should happen once per year" }
  validates :name, presence: true
end
