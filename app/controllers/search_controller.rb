class SearchController < ApplicationController
  def index
  	@marcas_form = Make.all.order("name")
    @states_form = State.where("country_id = ?",2)
    make_id = params[:make]
    @models_form = Model.where("make_id = ?",make_id).order("name")

    if !params[:make].blank?
      @marca = params[:make]
    end
    if !params[:model].blank?
      @modelo = params[:model]
    end
    if !params[:state].blank?
      @state = params[:state]
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

    @limit = 20

    @results = Advert.search_make("#{@marca}").search_model("#{@modelo}").search_state("#{@state}").search_year("#{params[:year1]}","#{params[:year2]}").search_price("#{params[:price1]}","#{params[:price2]}").order("price DESC").limit(@limit).offset(0)
    
    #sort data by price
    #@results = @results.sort_by {|precio|  
    #  precio.price
    #}.reverse
    
    #remove duplicates
    @results = @results.uniq{|x|[x['url'],x['price'],x['km'],x['comment']]}
    
    #session[:results] = @results
    #@results = @results[0..9]
  end

=begin
  def result
    if !params[:make].blank?
      @marca = params[:make]
    end
    if !params[:model].blank?
      @modelo = params[:model]
    end
    if !params[:state].blank?
      @state = params[:state]
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
   
    @results = Advert.search_make("#{@marca}").search_model("#{@modelo}").search_state("#{@state}").search_year("#{params[:year1]}","#{params[:year2]}").search_price("#{params[:price1]}","#{params[:price2]}")
    
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
=end

  def more   
    num = params[:num]
    if !params[:make].blank?
      @marca = params[:make]
    end
    if !params[:model].blank?
      @modelo = params[:model]
    end
    if !params[:state].blank?
      @state = params[:state]
    end
    
    @modelo ||= ""
    @marca ||= ""
    @state ||= ""
    params[:year1] ||= ""
    params[:year2] ||= ""
    params[:price1] ||= ""
    params[:price2] ||= ""

    @limit = 20
    @init = num.to_i*@limit
    @end = @init+@limit

    @results = Advert.search_make("#{@marca}").search_model("#{@modelo}").search_state("#{@state}").search_year("#{params[:year1]}","#{params[:year2]}").search_price("#{params[:price1]}","#{params[:price2]}").order("price DESC").limit(@limit).offset("#{@init}")
    #@results = @results[@init..@end]
    
    respond_to do |format|
      format.html { render :partial => 'partials/results' } # index.html.erb
      format.json { render json: @results }
    end
  end

  def getmodels
  	make_id = params[:make_id]
    @models = Model.where("make_id = ?",make_id).order("name")
    respond_to do |format|
    	format.json { render json: @models }
    end
  end
end
