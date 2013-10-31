class IndexController < ApplicationController
  def index
  	@marcas = Make.all(:order => 'name')
    @states = State.where("country_id = ?",2)
  end
end
