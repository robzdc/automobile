class Advert < ActiveRecord::Base
	scope :search_make, ->(make) { where("make = ?",make) if !make.empty? }
  scope :search_model, ->(model) { where("model = ?",model) if !model.empty? }
  scope :search_state, ->(state) { where("state = ?",state) if !state.empty? }
  scope :search_year, ->(year1,year2) { where("year BETWEEN ? AND ?",year1,year2) if !year1.empty? || !year2.empty? }
  scope :search_price, ->(price1,price2) { where("price BETWEEN ? AND ?",price1,price2) if !price1.empty? || !price2.empty? }
end
