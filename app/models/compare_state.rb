class CompareState < ActiveRecord::Base
	has_many :states
  has_many :websites
end
