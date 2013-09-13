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
=begin
  def result

  	session[:results] = []
    # Call next page
    if !params[:page].blank?
      page = params[:page].to_i * 5
      
      @soloautos_page = "&pagina=#{page}"
      @autoplaza_page = "MaxHits=#{page+5}&Offset=#{page}"
      @autocompro_page = "&limitstart=#{page}"
    else
      @autoplaza_page = "MaxHits=5&Offset=0"
    end
    # Filter by Make
    if !params[:make].blank?
      @marca = params[:make]
      @soloautos_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 1)
      if !@soloautos_marca.blank? 
        @soloautos_marca = "&marca=#{@soloautos_marca[0].value}"
        @soloautos_total = 0
      end
      @autoplaza_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 2)
      if !@autoplaza_marca.blank?
        @autoplaza_marca = "&Filter:marca=#{@autoplaza_marca[0].value}"
      end
      @autocompro_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 3)
      if !@autocompro_marca.blank?
        @autocompro_marca = "&maid=#{@autocompro_marca[0].value}"
      end
      @mercadolibre_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 4)
      if !@mercadolibre_marca.blank?
        @mercadolibre_marca = "#{@mercadolibre_marca[0].value}/"
      end
      
      if params[:state].to_i == 26 #check if state is Sonora
        @seminuevossonora_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 5)
        if !@seminuevossonora_marca.blank?
          @seminuevossonora_total = @seminuevossonora_marca.length    
        else
          @seminuevossonora_total = 0
        end
      end
      
    end
    
    # Filter by Model
    @soloautos_model_found = false
    @autocompro_model_found = false   
    @autoplaza_model_found = false   
    @mercadolibre_model_found = false
    if !params[:model].blank?
      @model = params[:model]
 
      @soloautos_model = CompareModel.where("model_id = ? AND website_id = ?",@model, 1)
      @soloautos_total = @soloautos_model.length
      if !@soloautos_model.blank?
        @soloautos_model_get = "&modelo="
        @soloautos_model_found = true
      else
        @soloautos_model_get = "" 
        @soloautos_model = ""
      end
      @autoplaza_model = CompareModel.where("model_id = ? AND website_id = ?",@model, 2)
      if !@autoplaza_model.blank?
        @autoplaza_model = "&Filter:modelo=#{@autoplaza_model[0].value}"
        @autoplaza_model_found = true 
      else
        @autoplaza_model = ""
      end
      @autocompro_model = CompareModel.where("model_id = ? AND website_id = ?",@model, 3)
      if !@autocompro_model.blank?
        @autocompro_model = "&moid=#{@autocompro_model[0].value}"
        @autocompro_model_found = true
      else
        @autocompro_model = ""
      end
      @mercadolibre_model = CompareModel.where("model_id = ? AND website_id = ?",@model, 4)
      if !@mercadolibre_model.blank?
        @mercadolibre_model = "#{@mercadolibre_model[0].value}/"
        @mercadolibre_model_found = true 
      else
        @mercadolibre_model = ""
      end
      
      if params[:state].to_i == 26 #check if state is Sonora
        @seminuevossonora_marca = CompareModel.where("model_id = ? AND website_id = ?",@model, 5)
        if !@seminuevossonora_marca.blank?
          @seminuevossonora_total = @seminuevossonora_marca.length 
        else
          @seminuevossonora_total = 0
        end
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
      
      @mercadolibre_state = CompareState.where("state_id = ? AND website_id = ?",@state, 4)
      @mercadolibre_state = "#{@mercadolibre_state[0].value}"
    end
    #filter price
    if !params[:price1].blank? || !params[:price2].blank?
      @price1 = params[:price1]
      @price2 = params[:price2]
      
      @soloautos_price = "&precio1=#{@price1}&precio2=#{@price2}"
      @autocompro_price = "&minprice=#{@price1}&maxprice=#{@price2}"
      @mercadolibre_price = "_PriceRange_#{@price1}-#{@price2}"
      @seminuevossonora_price = "&p1=#{@price1}&p2=#{@price2}"
    end
    
    #filter year
    if !params[:year1].blank? || !params[:year2].blank?
      @year1 = params[:year1]
      @year2 = params[:year2]
      
      @soloautos_year = "&anio1=#{@year1}&anio2=#{@year2}"
      @autocompro_year = "&minyear=#{@year1}&maxyear=#{@year2}"
      @mercadolibre_year = "_YearRange_#{@year1}-#{@year2}"
      @seminuevossonora_year = "&a1=#{@year1}&a2=#{@year2}"
    end
    
    #Call Functions
    @array = []
    
    begin
      if !@soloautos_marca.blank?
        
        res_soloautos = Net::HTTP.get_response(URI.parse("http://autos-usados.soloautos.com.mx/busqueda/autos/"))
        
        if(res_soloautos.code.to_i == 200 || res_soloautos.code.to_i == 301) 
          if @soloautos_total > 1
            (0..(@soloautos_total-1)).each do |i|
              soloautos(URI.encode("http://autos-usados.soloautos.com.mx/busqueda/autos/?#{@soloautos_marca}#{@soloautos_model_get}#{@soloautos_model[i].value}#{@soloautos_state}#{@soloautos_price}#{@soloautos_year}&orden=4"))
              @array = @soloautos
            end
          else
            if !@soloautos_model.blank? 
              @soloautos_model = @soloautos_model[0].value
              soloautos(URI.encode("http://autos-usados.soloautos.com.mx/busqueda/autos/?#{@soloautos_marca}#{@soloautos_model_get}#{@soloautos_model}#{@soloautos_state}#{@soloautos_price}#{@soloautos_year}&orden=4"))
              @array = @soloautos
            else
              soloautos(URI.encode("http://autos-usados.soloautos.com.mx/busqueda/autos/?#{@soloautos_marca}#{@soloautos_state}#{@soloautos_price}#{@soloautos_year}&orden=4"))              
              @array = @soloautos
            end
          end
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
    
    begin
      if !@autoplaza_marca.blank? 
        res_autoplaza = Net::HTTP.get_response(URI.parse("http://usados.autoplaza.com.mx")) 
        if(res_autoplaza.code.to_i == 200 || res_autoplaza.code.to_i == 301)
           @time = Time.now
          autoplaza(URI.encode("http://autos-usados.autoplaza.com.mx/Autos/SearchResultPage.aspx?IsFql=False&Query=&AdditionalQuery=&Offset=0&MaxHits=9999#{@autoplaza_marca}#{@autoplaza_model}#{@autoplaza_state}"),@price1,@price2,@year1,@year2)
          @time3 = Time.now - @time
          puts @time3
          if @array.blank? 
            @array = @autoplaza
          else
            @array.concat @autoplaza
          end
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
    
    begin
      if !@autocompro_marca.blank?
      res_autocompro = Net::HTTP.get_response(URI.parse("http://autocom.pro/"))
        if(res_autocompro.code.to_i == 200 || res_autocompro.code.to_i == 301)
          if !@autocompro_model.blank?
            autocompro(URI.encode("http://autocom.pro/results?#{@autocompro_state}#{@autocompro_marca}#{@autocompro_model}#{@autocompro_page}&limit=9999#{@autocompro_price}#{@autocompro_year}"))   
            if @array.blank? 
              @array = @autocompro
            else
              @array.concat @autocompro
            end
          elsif @model.blank?
            autocompro(URI.encode("http://autocom.pro/results?#{@autocompro_state}#{@autocompro_marca}#{@autocompro_page}&limit=9999#{@autocompro_price}#{@autocompro_year}"))   
            if @array.blank? 
              @array = @autocompro
            else
              @array.concat @autocompro
            end
          else
            
          end
        end
      end
    rescue Timeout::Error => exc
      puts "ERROR: #{exc.message}"
    end
    
    begin 
      if !@mercadolibre_marca.blank?
      res_mercadolibre = Net::HTTP.get_response(URI.parse("http://autos.mercadolibre.com.mx/"))
        if(res_mercadolibre.code.to_i == 200 || res_mercadolibre.code.to_i == 301)
          mercadolibre(URI.encode("http://autos.mercadolibre.com.mx/#{@mercadolibre_marca}#{@mercadolibre_model}#{@mercadolibre_state}#{@mercadolibre_price}#{@mercadolibre_year}"))  
          if @array.blank? 
            @array = @mercadolibre
          else
            @array.concat @mercadolibre
          end
        end
      end
    rescue Timeout::Error => exc
      puts "ERROR: #{exc.message}"
    end
    
    begin
      if @state.to_i == 26 #check if state is Sonora
        if @seminuevossonora_total  != 0
        res_seminuevossonora = Net::HTTP.get_response(URI.parse("http://seminuevossonora.com/"))
          if(res_seminuevossonora.code.to_i == 200 || res_seminuevossonora.code.to_i == 301)
            if @seminuevossonora_total > 1
              (0..(@seminuevossonora_total.length - 1)).each do |i|
                seminuevossonora(URI.encode("http://seminuevossonora.com/autos?order=field_precio_amount&sort=desc&buscar=#{@seminuevossonora_marca[i].value}&s=1#{@seminuevossonora_price}#{@seminuevossonora_year}"))
                @array = @seminuevossonora
              end
            else
              seminuevossonora(URI.encode("http://seminuevossonora.com/autos?order=field_precio_amount&sort=desc&buscar=#{@seminuevossonora_marca[0].value}&s=1#{@seminuevossonora_price}#{@seminuevossonora_year}"))
                @array = @seminuevossonora  
            end
          end
        end
      end
    rescue Timeout::Error => exc
      puts "ERROR: #{exc.message}"
    rescue Errno::ECONNRESET => exc
      puts "Error: #{exc.message}"
    end
  
    #sort data
    puts @array.length
    @results = @array.sort_by {|precio|  
       precio[0]['price'] 
    }.reverse
    
    session[:results] = @results
    @results = @results[0..9]
    
    respond_to do |format|
      format.html { render :partial => 'partials/results' } # index.html.erb
      format.json { render json: @results, :callback => params[:callback] }
    end
  end
=end
  def result
    if !params[:make].blank?
      @marca = params[:make]
      #autoplaza
      #@autoplaza_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 2)
      #@autoplaza_marca = @autoplaza_marca[0].value
      #mercadolibre
      #@mercadolibre_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 4)
      #@mercadolibre_marca = @mercadolibre_marca[0].value
      #seminuevossonora
      #@seminuevossonora_marca = CompareMake.where("make_id = ? AND website_id = ?",@marca, 5)
      #@seminuevossonora_marca = @seminuevossonora_marca[0].value
    end
    if !params[:model].blank?
      @modelo = params[:model]
      #autoplaza
      #@autoplaza_model = CompareModel.where("model_id = ? AND website_id = ?",@modelo, 2)
      #@autoplaza_model = @autoplaza_model[0].value
      #mercadolibre
      #@mercadolibre_model = CompareModel.where("model_id = ? AND website_id = ?",@modelo, 4)
      #@mercadolibre_model = @mercadolibre_model[0].value
      #seminuevossonora
      #@seminuevossonora_model = CompareModel.where("model_id = ? AND website_id = ?",@modelo, 5)
      #@seminuevossonora_model = @seminuevossonora_model[0].value
    end
    if !params[:state].blank?
      @state = params[:state]
      #autoplaza
      #@autoplaza_state = CompareState.where("state_id = ? AND website_id = ?",@state, 2)
      #@autoplaza_state = @autoplaza_state[0].value
      #mercadolibre
      #@mercadolibre_state = CompareState.where("state_id = ? AND website_id = ?",@state, 4)
      #@mercadolibre_state = @mercadolibre_state[0].value
      #seminuevossonora
      #@seminuevossonora_state = CompareState.where("state_id = ? AND website_id = ?",@state, 5)
      #@seminuevossonora_state = @seminuevossonora_state[0].value
    end
    
    @modelo ||= ""
    @marca ||= ""
    @state ||= ""
    #autoplaza
    @autoplaza_marca ||= ""
    @autoplaza_model ||= ""
    @autoplaza_state ||= ""
    #mercadolibre
    @mercadolibre_marca ||= ""
    @mercadolibre_model ||= ""
    @mercadolibre_state ||= ""
    #seminuevossonora
    @seminuevossonora_marca ||= ""
    @seminuevossonora_model ||= ""
    @seminuevossonora_state ||= ""
    params[:year1] ||= ""
    params[:year2] ||= ""
    params[:price1] ||= ""
    params[:price2] ||= ""
   
    @results = Advert.search_make("#{@marca}").search_model("#{@model}").search_state("#{@state}").search_year("#{params[:year1]}","#{params[:year2]}").search_price("#{params[:price1]}","#{params[:price2]}").all
    
    #sort data by price
    @results = @results.sort_by {|precio|  
      precio.price
    }.reverse
    
    #remove duplicates
    @results = @results.uniq{|x|[x['title'],x['price'],x['km'],x['comment']]}
    
    session[:results] = @results
    @results = @results[0..9]

    respond_to do |format|
      format.html { render :partial => 'partials/results' } # index.html.erb
      format.json { render json: @results, :callback => params[:callback] }
    end
  end
  
  def more
    
    num = params[:num]
    
    @init = num.to_i*10
    @end = @init+10
    @results = session[:results]
    @results = @results[@init..@end]
    
    respond_to do |format|
      format.html { render :partial => 'partials/results' } # index.html.erb
      format.json { render json: @results }
    end
  end
  
  #Get models by make
  def getmodels 
    make_id = params[:make_id]
    @models = Model.where("make_id = ?",make_id).order("name")
    respond_to do |format|
    	format.json { render json: @models }
    end
  end

end
