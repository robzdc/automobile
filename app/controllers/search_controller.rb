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
  	
    # Call next page
    if !params[:page].blank?
      page = params[:page].to_i * 5
      
      @soloautos_page = "&pagina=#{page}"
      @autoplaza_page = "MaxHits=#{page+5}&Offset=#{page}"
      @autocompro_page = "&limitstart=#{page}"
    else
      @autoplaza_page = "MaxHits=5&Offset=0"
    end
    # Verify if search is by make
    if !params[:make].blank?
      @marca = params[:make]
      @soloautos_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 1)
      if !@soloautos_marca.blank?
        @soloautos_marca = "&marca=#{@soloautos_marca[0].value}"
      end
      @autoplaza_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 2)
      if !@autoplaza_marca.blank?
        @autoplaza_marca = "&Filter:marca=#{@autoplaza_marca[0].value}"
      end
      @autocompro_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 3)
      if !@autocompro_marca.blank?
        @autocompro_marca = "&maid=#{@autocompro_marca[0].value}"
      end
    end
    #call state
    if !params[:state].blank?
    	@state = params[:state]
      @autoplaza_state = CompareState.where("state_id = ? AND website_id = ?",@state, 2)
      @autoplaza_state = "&Filter:estado=#{@autoplaza_state[0].value}"
      
      @soloautos_state = CompareState.where("state_id = ? AND website_id = ?",@state, 1)
      @soloautos_state = "&estado=#{@soloautos_state[0].value}"
      
      @autocompro_state = CompareState.where("state_id = ? AND website_id = ?",@state, 3)
      @autocompro_state = "&estado=#{@autocompro_state[0].value}"
    end
    #filter price
    if !params[:price1].blank? || !params[:price2].blank?
      @price1 = params[:price1]
      @price2 = params[:price2]
      
      @soloautos_price = "&precio1=#{@price1}&precio2=#{@price2}"
      @autocompro_price = "&minprice=#{@price1}&maxprice=#{@price2}"
    end
    
    #Call Functions
    @array = []
    res_soloautos = Net::HTTP.get_response(URI.parse("http://autos-usados.soloautos.com.mx/busqueda/autos/"))
    if res_soloautos.code.to_i == 200
      soloautos(URI.encode("http://autos-usados.soloautos.com.mx/busqueda/autos/?#{@soloautos_marca}#{@soloautos_state}#{@soloautos_price}&orden=4"))
    	@array = @soloautos
    end
    
    begin
      res_autoplaza = Net::HTTP.get_response(URI.parse("http://usados.autoplaza.com.mx")) 
      if res_autoplaza.code.to_i == 200 
        autoplaza(URI.encode("http://autos-usados.autoplaza.com.mx/Autos/SearchResultPage.aspx?IsFql=False&Query=&AdditionalQuery=&MaxHits=9999#{@autoplaza_page}#{@autoplaza_marca}#{@autoplaza_state}"),@price1,@price2)
        if @array.empty? 
          @array = @autoplaza
        else
          @array.concat @autoplaza
        end
      end
    rescue Errno::ECONNREFUSED => exc
      puts "ERROR: #{exc.message}"
    rescue Errno::ECONNRESET => exc
      puts "ERROR: #{exc.message}"
    rescue Timeout::Error => exc
      puts "ERROR: #{exc.message}"
    rescue Errno::ETIMEDOUT => exc
    	puts "ERROR: #{exc.message}"
    end
    
    res_autocompro = Net::HTTP.get_response(URI.parse("http://autocom.pro/"))
    if res_autocompro.code.to_i == 200
      autocompro(URI.encode("http://autocom.pro/results?#{@autocompro_state}#{@autocompro_marca}#{@autocompro_page}&limit=9999#{@autocompro_price}"))  
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
    
    session[:results] = @results
    
    respond_to do |format|
      format.html { render :partial => 'partials/results', :locals => { :marca => @marca, :state => @state} } # index.html.erb
      format.json { render json: @results, :callback => params[:callback] }
    end
  end
  
  def more(num)
    respond_to do |format|
      format.json { render json: session[:results] }
    end
  end

end
