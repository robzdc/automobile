# encoding: UTF-8
require 'seminuevos' 
require 'open-uri'
require 'spreadsheet'
require 'net/http'

class SearchController < ApplicationController
  include SemiNuevos
  
  def index
    @marcas = Make.all(:order => 'name')
    @states = State.where("country_id = ?",2)
  end

  def result
    if !params[:make].empty?
    	marca = params[:make]
      @autoplaza_marca = CompareMake.where("make_id = ? AND website_id = ?",marca, 2)
      if !@autoplaza_marca.empty?
        @autoplaza_marca = "&Filter:marca=#{@autoplaza_marca[0].value}"
      end
      @soloautos_marca = CompareMake.where("make_id = ? AND website_id = ?",marca, 1)
      if !@soloautos_marca.empty?
        @soloautos_marca = "&marca=#{@soloautos_marca[0].value}"
      end
      @autocompro_marca = CompareMake.where("make_id = ? AND website_id = ?",marca, 3)
      if !@autocompro_marca.empty?
        @autocompro_marca = "&maid=#{@autocompro_marca[0].value}"
      end
    end
    
    if !params[:state].empty?
    	state = params[:state]
      @autoplaza_state = CompareState.where("state_id = ? AND website_id = ?",state, 2)
      @autoplaza_state = "&Filter:estado=#{@autoplaza_state[0].value}"
      
      @soloautos_state = CompareState.where("state_id = ? AND website_id = ?",state, 1)
      @soloautos_state = "&estado=#{@soloautos_state[0].value}"
      
      @autocompro_state = CompareState.where("state_id = ? AND website_id = ?",state, 3)
      @autocompro_state = "&estado=#{@autocompro_state[0].value}"
    end
     
    #Call Functions
    @array = []
    
    res_soloautos = Net::HTTP.get_response(URI.parse("http://autos-usados.soloautos.com.mx/busqueda/autos/"))
    if res_soloautos.code.to_i == 200
    	soloautos(URI.encode("http://autos-usados.soloautos.com.mx/busqueda/autos/?#{@soloautos_marca}#{@soloautos_state}"))
    	@array = @soloautos
    end
    
    res_autoplaza = Net::HTTP.get_response(URI.parse("http://usados.autoplaza.com.mx")) 
    if res_autoplaza.code.to_i == 200 
    	autoplaza(URI.encode("http://www.autos-usados.autoplaza.com.mx/Autos/SearchResultPage.aspx?IsFql=False&Query=&AdditionalQuery=&MaxHits=20&Offset=0#{@autoplaza_marca}#{@autoplaza_state}"))
      if @array.empty? 
        @array = @autoplaza
      else
        @array.concat @autoplaza
      end
    end
    
    res_autocompro = Net::HTTP.get_response(URI.parse("http://autocom.pro/"))
    if res_autocompro.code.to_i == 200
    	autocompro(URI.encode("http://autocom.pro/results?#{@autocompro_state}#{@autocompro_marca}"))  
      if @array.empty? 
        @array = @autocompro
      else
        @array.concat @autocompro
      end
    end
  
    #sort data
    @results = @array.sort_by {|precio|  
       precio[0]['price'] 
    }.reverse
    
    respond_to do |format|
      format.html { render :partial => 'partials/results' } # index.html.erb
      format.json { render json: @results, :callback => params[:callback] }
    end
  end

end
