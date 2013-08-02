# encoding: UTF-8
require 'import' 

class IndexController < ApplicationController
 	#include ImportsDB
  
  def index
			#seminuevossonora_model
      @marcas = Make.all(:order => 'name')
      @states = State.where("country_id = ?",2)
  end
  
end
