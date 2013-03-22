# encoding: UTF-8
require 'seminuevos' 
require 'open-uri'
require 'spreadsheet'
require 'net/http'

class SearchController < ApplicationController
  include SemiNuevos
  
  def result
    
    if params[:make]
    	marca = params[:make]
      @autoplaza_marca = CompareMake.where("make_id = ? AND website_id = ?",marca, 2)
      @soloautos_marca = CompareMake.where("make_id = ? AND website_id = ?",marca, 1)
    end
    
    if params[:state]
    	state = params[:state]
      autoplaza_state = CompareState.where("state_id = ? AND website_id = ?",state, 2)
      soloautos_state = CompareState.where("state_id = ? AND website_id = ?",state, 1)
      soloautos_state = "&estado=#{@soloautos_state[0].value}"
    end
		puts soloautos_state
      
    #call functions
    #res = Net::HTTP.get_response(URI.parse("http://autos-usados.soloautos.com.mx/busqueda/autos/"))
    #res.code
    soloautos(URI.encode("http://autos-usados.soloautos.com.mx/busqueda/autos/?marca=#{@soloautos_marca[0].value}"))
    autoplaza(URI.encode("http://www.autos-usados.autoplaza.com.mx/Autos/SearchResultPage.aspx?IsFql=False&Query=&AdditionalQuery=&MaxHits=99999&Offset=0&Filter:marca=#{@autoplaza_marca[0].value}&Filter:estado=#{@autoplaza_state[0].value}&Filter:year=2010"))
    
    #concat arrays
    @soloautos.concat @autoplaza
    
    #sort data
    @results = @soloautos.sort_by {|precio|  
       precio[0]['price'] 
    }.reverse
  end
end
