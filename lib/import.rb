# encoding: UTF-8
module ImportsDB
  #soloautos = 1   //integer
	#autoplaza = 2   //string
  #autocom.pro = 3   //integer
  #mercadolibre = 4   //string
  
  def makes
    #insert makes
    require 'spreadsheet'
   	book = Spreadsheet.open "public/AUTOPRECIOS_EL_UNIVERSAL.xls"
    sheet1 = book.worksheet 0
    sheet1.each 1 do |row|
      @existe = Make.find_by_name(row[1])
      
      if @existe.nil?
        make = Make.new(:name => row[1])
        make.save
        puts row[1]
      end
      
    end
  end
  
  def compare_makes
    #COMPARE MAKE
    #CompareMake.delete_all
    marca = Make.all
    marca.each do |row|
      @existe = CompareMake.where("make_id = ? AND website_id = ?",row.id,2)
      if @existe.empty?
        value = row.name.strip.split(" ").join("-")
        compare = CompareMake.new(:make_id => row.id, :website_id => 2, :value => value)
        compare.save
        puts value
      end
    end
  end
  
  def models
    #insert models
    require 'spreadsheet'
   	book = Spreadsheet.open "public/AUTOPRECIOS_EL_UNIVERSAL.xls"
    sheet1 = book.worksheet 0
    sheet1.each 13695 do |row|
      @existe = Model.find_by_name(row[4])
 
      if @existe.blank?
        @marca = Make.find_by_name(row[1].split(" ")[0])
        if !@marca.blank?
          model = Model.new(:make_id => @marca.id, :name => row[4])
          model.save
          puts row[4]
        end
      end 
      
    end
  end
  
  def compare_models
    #COMPARE MODEL
    #CompareModel.delete_all
    model = Model.all
    model.each do |row|
      @existe = CompareModel.where("model_id = ? AND website_id = ?",row.id,2)
      if @existe.blank?
        value = row.name.strip.split(" ").join("-")
        compare = CompareModel.new(:model_id => row.id, :website_id => 2, :value => value)
        compare.save
        puts value
      end
    end
  end
  
  def states
    #insert makes
    require 'spreadsheet'
    book = Spreadsheet.open "public/jos_estados.xls"
    sheet1 = book.worksheet 0
    sheet1.each do |row|
      @existe = State.find_by_name(row[1])
      
      if @existe.nil?
        state = State.new(:name => row[1], :active => row[2].to_i)
        state.save
        #puts row[2].to_i
      end
      
    end
  end
  
  def compare_states
    #COMPARE States
    #CompareState.delete_all
    state = State.all
    state.each do |row|
      @existe = CompareState.where("state_id = ? AND website_id = ?",row.id,4)
      if @existe.empty?
        value = row.name.strip.split(" ").join("-")
        compare = CompareState.new(:state_id => row.id, :website_id => 4, :value => "_PciaId_#{value}")
        compare.save
        #_PciaId_Nuevo-Leon
        puts "_PciaId_#{value}"
      end
    end
  end
  
  def carsmexico_makes
    require 'open-uri'
    doc = Nokogiri::HTML(open(URI.encode("http://autos.mercadolibre.com.mx/")))
    
    doc.css('.aside > div > dl:nth-of-type(1) dd dl dd a').each do |makes|

        @existe = CompareMake.where("value = ? AND website_id = ?",makes.content.downcase.strip,4)
        if @existe.blank?
          @marca = Make.where("name = ?",makes.content.strip)
          value = makes.content.downcase.strip.split(" ").join("-")
          if !@marca.blank?
            compare = CompareMake.new(:make_id => @marca[0].id, :website_id => 4, :value => value)
            #compare.save
            puts "#{@marca[0].id} #{value}"
          end
        end 
      
    end
    
    doc.css('.aside > div > dl:nth-of-type(1) dd a').each do |makes|
      
        @existe = CompareMake.where("value = ? AND website_id = ?",makes.content.downcase.strip,4)
        if @existe.blank?
          @marca = Make.where("name = ?",makes.content.strip)
          value = makes.content.downcase.strip.split(" ").join("-")
          if !@marca.blank?
            compare = CompareMake.new(:make_id => @marca[0].id, :website_id => 4, :value => value)
            #compare.save
            puts "#{@marca[0].id} #{value}"
          end
        end
 
    end
  end
  
  def carsmexico_models 
    
    makes = Make.joins("INNER JOIN compare_makes ON makes.id = compare_makes.make_id").where("website_id = ?","4")
    
    makes.each do |makes|
      
      model = Model.where("make_id = ?",makes.id)
      model.each do |model|
        value = model.name.downcase.strip.split(" ").join("-")
        @existe = CompareModel.where("value = ? AND website_id = ?",value,4)
        if @existe.blank?
          
          compare = CompareModel.new(:model_id => model.id, :website_id => 4, :value => value)
          #compare.save
          
          puts "#{model.id} #{value}"
        end  
      end
     
    end
  end
  
  def semunuevossonora_makes
    require 'open-uri'
    doc = Nokogiri::HTML(open(URI.encode("http://seminuevossonora.com/")))
    
    doc.css('#edit-modelo-hierarchical-select-selects-0 option').each do |makes|
      @existe = CompareMake.where("value = ? AND website_id = ?",makes.attr("value"),5)
      if @existe.blank?
        @marca = Make.where("name = ?",makes.text)
        if !@marca.blank?
            compare = CompareMake.new(:make_id => @marca[0].id, :website_id => 5, :value => makes.attr("value"))
            #compare.save
            puts makes.text
        end
      end
    end 
  end
  
  def seminuevossonora_model
    require 'open-uri'
    require 'net/http'
    uri = URI.parse(URI::escape("http://seminuevossonora.com/"))
    req = Net::HTTP::Post.new(uri.host)
    puts uri.hostname
    req.set_form_data( 'modelo[hsid]' => '0','year1'=>'','year2' => '','precio1' =>'','precio2'=>'', 'modelo[hierarchical_select][selects][0]' => '49', 's1' => '1', 'form_id' => 'central_form', 'hs_form_build_id'=> 'hs_form_4031c6477db37e107ed9757c92106ade', 'hsid' => '0', 'client_supports_caching' => 'true', 'form_build_id' => 'form-14dcc123b99608b7bf2334454a2b211f')
    
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      puts "OK"
    else
      res.value
    end
  end
  
end