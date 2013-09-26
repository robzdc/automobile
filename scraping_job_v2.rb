module Scraping
  require 'open-uri'
  require 'spreadsheet'
  require 'net/http'
  
  # soloautos.com
  def self.soloautos(site,make,model,state,year1)
    res = Net::HTTP.get_response(URI.parse(site))
    
    if res.code != 200
      @error500 = true
    end
    
    doc2 = Nokogiri::HTML(open(site))
    
    @noresults = false
    #initialize variables
    @soloautos = []
    
    #get total pages
    @pages = (doc2.css("#nav:first > #numbers").length)
    
    #verify if return 0 results
    if doc2.css(".left.w560.lh130.mt10.gray.br10.b.t13.tc.pd10.gris-obscuro").length > 0
      @noresults = true
    end
    
    if !@noresults
      for i in 0..@pages do
  
        doc = Nokogiri::HTML(open(site+"&por_pagina=30&pagina=#{i*30}"))
        
          doc.css('.resultado').each do |auto|
            
            #get image
            auto.css('.img_res').each do |imagen|
              if !imagen['src'].include? 'http'
                imagen['src'] = 'http://autos-usados.soloautos.com.mx/'+imagen['src']   
              end
              imagen = imagen['src'].to_s
              
              @image =  imagen
            end
            
            #get title
            auto.css('div.cien.left span a').each do |titulo|
              @title = titulo.content
              @href = titulo['href']
            end
            
            #get price 
            auto.css('.rojo.t16').each do |precio|
              price = precio.content
              price.slice! "$"
              price.slice! "MN"
              
              @price = price.strip.delete(',').to_i
            end
            
            #get location
            auto.css('.w80.left.h30.tc.pt5').each do |location|
              note=location.search("span")
              note.remove()
              note=location.search("br")
              note.remove()
              @location = location.content.strip.to_s
            end
            
            #get phone
            auto.css('.mt05.t14.lh100').each do |phone|
              @phone = phone.content.strip.to_s
            end
            
            #get comments
            auto.css('.ml10.left.w420 > .lh110.gris-obscuro.mb05').each do |comments|
              note=comments.search("strong")
              note.remove()
              note=comments.search("a")
              note.remove()
              @comment = comments.content.strip.to_s
            end
            
            #get km
            auto.css('.left.cien.mt05.mb05 strong').each do |km|
              km = km.content
              km.slice! "km."
              
              @km = km.strip.delete(',').to_i
            end 
            
            if !@image.nil?  #create only array with data
              @soloautos << [
                'image' => @image,
                'title' => @title, 
                'url' => "#{@href}", 
                'price' => @price, 
                'location' => @location,
                'phone' => @phone,
                'comment' => @comment,
                'color' => '',
                'km' => @km,
                'make' => make,
                'model' => model,
                'state' => state,
                'year' => year1
              ]
            end  
          end
      end  #while
    end   
  end
    
  # autoplaza.com
  def self.autoplaza(site,make,model,state,year1)
      
      doc = Nokogiri::HTML(open(site))
      
      #initialize variables
      @autoplaza = []
      
      doc.css('#resultList li').each do |auto|
        
        #get image
        auto.css('.contPic a img').each do |imagen|
          
          imagen_th = imagen['src'].gsub('-100-', '-240-')
          @image =  imagen_th.to_s
        end
        
        #get title
        auto.css('.descriptCar a h2').each do |titulo|
          @title = titulo.content.strip
          @href = titulo['href']
        end
        
        #get URL
        auto.css('.descriptCar a').each do |url|
          @href = url['href']
        end
        
        #get location
        auto.css('.descriptCar a p b:first').each do |location|
          @location = location.content.to_s
        end
        
        #get comments
        auto.css('.descriptCar a p').each do |comments|
          note=comments.search("br")
          note.remove()
          note=comments.search("b")
          note.remove()
          @comment = comments.content.strip.to_s
        end
        
        #get km
        auto.css('.kilometro').each do |km|
          km = km.content
          km.slice! "KM"
          
          @km = km.strip.delete(',').to_i
        end
        
        #get price 
        auto.css('.precio').each do |precio|
          price = precio.content
          note=precio.search("br")
          note.remove()
          
          price.slice! "$"
          price.slice! "M.N."
          
          @price = price.strip.delete(',').to_i
        end
        
        #get year
        auto.css('.descriptCar a h2').each do |year|
          year = year.content.split(" ").last
          
          @year = year.to_i
          
          @saltar2 = false
          if (!year1.blank? && @year < year1.to_i)
            @saltar2 = true
          end
          if (!year1.blank? && @year > year1.to_i)
            @saltar2 = true
          end
        end
        
        if (!@image.nil? && !@saltar2)  #create only array with data
          @autoplaza << [
            'image' => @image,
            'title' => @title, 
            'url' => 'http://www.autos-usados.autoplaza.com.mx/Autos/' + @href, 
            'price' => @price, 
            'location' => @location,
            'phone' => '',
            'comment' => @comment,
            'color' => '',
            'km' => @km,
            'make' => make,
            'model' => model,
            'state' => state,
            'year' => year1
            ]
        end 
      end  
    end
    
  # autocom.pro
    def self.autocompro(site,make,model,state,year1)
    doc = Nokogiri::HTML(open(site))
    
    #initialize variables
    @autocompro = []
    
    doc.css('#products-list tr.alt:not(.border)').each do |auto|
      #get image
      auto.css('td .rel-thumb a img').each do |imagen|
        imagen = imagen['src'].to_s
        
        @image =  imagen
        
      end
      
      #get title
      auto.css('h3.hb-7 a').each do |titulo|
        @title = titulo.content
      end
      
      #get URL
      auto.css('h3.hb-7 a').each do |url|
        @href = url['href']
      end
      
      #get price 
      auto.css('td.col-list-price').each do |precio|
        price = precio.content

        price.slice! "$"
        
        @price = price.strip.delete(',').to_i
      end
      
      #get location
      auto.css('td .list-view-text strong:first').each do |location|
        @location = location.content.to_s
      end
      
      #get comments
      auto.css('td .list-view-text span').each do |comments|
        @comment = comments.content.strip.to_s
      end
      
      #get color
      auto.css('td .list-view-text strong:eq(1)').each do |color|
        @color = color.content.strip.to_s
      end
      
      #get km
      auto.css('td .list-view-text strong:eq(2)').each do |km|
        @km = km.content.strip.to_s
      end
      
      if !@image.nil?  #create only array with data
        @autocompro << [
          'image' => @image,
          'title' => @title, 
          'url' => "http://autocom.pro/#{@href}", 
          'price' => @price, 
          'location' => @location,
          'phone' => '',
          'comment' => @comment,
          'color' => @color,
          'km' => @km,
          'make' => make,
          'model' => model,
          'state' => state,
          'year' => year1
          ]
      end        
    end
  end
    
  # mercadolibre.com
  def self.mercadolibre(site,make,model,state,year1)
    @encontro_datos = true 
    @page = 1
    

    #initialize variables
    @mercadolibre = []
    
    while @encontro_datos do   #While site have results, request url
      doc = Nokogiri::HTML(open(site+"_Desde_#{@page}_DisplayType_LF_OrderId_PRICE*DESC"))
        
      if doc.search('#searchResults li').length == 0
        @encontro_datos = false
      end
      doc.css('#searchResults li.rowItem').each do |auto|  
        
        #get image
        auto.css('a.list-view-item-figure img').each do |imagen|
          imagen = imagen['src'].to_s
          
          @image =  imagen
        end
        
        #get title
        auto.css('h3.list-view-item-title a:first').each do |titulo|
          @title = titulo.content.strip  
          
        end
        
        #get URL
        auto.css('h3.list-view-item-title a:not(.favorite)').each do |url|
          @href = url['href']
        end
        
        #get price 
        auto.css('p.price-info span strong').each do |precio|
          price = precio.content
          
          price.slice! "$"
          
          @price = price.strip.delete(',').to_i
        end
        
        #get location
        auto.css('ul.extra-info .extra-info-location').each do |location|
          @location = location.content.to_s
        end
        
        #get phone
        auto.css('ul.extra-info .extra-info-phone').each do |phone|
          
          #telefono=phone.search("Tel.:")
          #telefono.remove()
          @phone = phone.content.strip.to_s
        end
        
        #get km
        auto.css('ul.classified-details .classified-details-item').each do |km|
          @km = km.content.strip.to_s
         
        end
        
        if !@image.nil?  #create only array with data
          @mercadolibre << [
            'image' => @image,
            'title' => @title, 
            'url' => @href, 
            'price' => @price, 
            'location' => @location,
            'phone' => @phone,
            'comment' => '',
            'color' => '',
            'km' => @km,
            'make' => make,
            'model' => model,
            'state' => state,
            'year' => year1
            ]
        end
       
      end
      #sum 51 results
      @page = @page+50
    end
  end
    
  #seminuevossonora.com
  def self.seminuevossonora(site,make,model,state,year1)
    @encontro_datos = true 
    @no_results = false
    @page = 0
    
    #initialize variables
    @seminuevossonora = []
    
    while @encontro_datos do   #While site have results, request url
      
      doc = Nokogiri::HTML(open(site+"&page=#{@page}"))
      
      if doc.search('.content .view-content').length == 0
        @no_results = true
      end
    
      if doc.search('.pager .pager-last').length == 0
        @encontro_datos = false
      end
      
      if !@no_results
        doc.css('.view-content table tr').each do |auto|  
          
          #get image
          auto.css('td.views-field-field-foto-fid a img').each do |imagen|
            imagen = imagen['src'].to_s
            
            @image =  imagen
          end
          
          #get title
          auto.css('.views-field-field-modelo-value').each do |titulo|
            @title = titulo.content.strip  
            
          end
          #get title
          auto.css('.views-field-field-modelo-value-1').each do |titulo|
            @title << ' ' + titulo.content.strip
            
          end
          #get title
          auto.css('.views-field-field-year-value span').each do |titulo|
            @title << ' ' + titulo.content.strip
            
          end
          
          #get URL
          auto.css('td.views-field-field-foto-fid a').each do |url|
            @href = "http://seminuevossonora.com/"+url['href']
          end
          
          #get price 
          auto.css('td.views-field-field-precio-amount').each do |precio|
            price = precio.content
            
            price.slice! "$"
            price.slice! "MXN"
            
            @price = price.strip.delete(',').to_i
          end
          
          if !@image.nil?  #create only array with data
            @seminuevossonora << [
              'image' => @image,
              'title' => @title, 
              'url' => @href, 
              'price' => @price, 
              'location' => '',
              'phone' => '',
              'comment' => '',
              'color' => '',
              'km' => '',
              'make' => make,
              'model' => model,
              'state' => state,
              'year' => year1
              ]
          end
          
        end
      end
      #sum 51 results
      @page = @page+1
    end
  end

  #Obtener anuncios de paginas y guardarlas en la base de datos
  def get_soloautos(make_num)
    @array = []
    states = State.where(:country_id => 2)
    states.each do |state|
      
      #soloautos
      @compare_state = CompareState.where(:state_id => state.id, :website_id => 1)
      makes = Make.where("id = ?",make_num)
      puts make_num 
      break
      makes.each do |make|
        @compare_make = CompareMake.where(:make_id => make.id, :website_id => 1)
        
        models = Model.where(:make_id => make.id)
        models.each do |model|
          @compare_model = CompareModel.where(:model_id => model.id, :website_id => 1)
          if !@compare_model.blank?
            @year = [1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014]
            @year.each do |year|
              begin
                soloautos(URI.encode("http://autos-usados.soloautos.com.mx/busqueda/autos/?&marca=#{@compare_make[0].value}&modelo=#{@compare_model[0].value}&estado=#{@compare_state[0].value}&precio1=&precio2=&anio1=#{year}&anio2=#{year}&orden=4"),make.id,model.id,state.id,year)
                @array.concat @soloautos
              rescue OpenURI::HTTPError => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ECONNREFUSED => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ECONNRESET => exc
                puts "ERROR: #{exc.message}"
              rescue Timeout::Error => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ETIMEDOUT => exc
                puts "ERROR: #{exc.message}"
              end
            end
          end
        end
      end
    end
    
    @array.each do |data|
      Advert.create(
        :image => data[0]["image"],
        :title => data[0]["title"],
        :url => data[0]["url"],
        :price => data[0]["price"],
        :location => data[0]["location"],
        :phone => data[0]["phone"],
        :comment => data[0]["comment"],
        :color => data[0]["color"],
        :km => data[0]["km"],
        :make => data[0]["make"],
        :model => data[0]["model"],
        :state => data[0]["state"],
        :year => data[0]["year"])
    end
  end
    
  def get_autoplaza(make_num)
    @array = []
    states = State.where(:country_id => 2).limit(1)
    states.each do |state| 

      #autoplaza
      @compare_state = CompareState.where(:state_id => state.id, :website_id => 2)
      makes = Make.where("id = ?",make_num)
      puts make_num 
      break
      makes.each do |make|
        @compare_make = CompareMake.where(:make_id => make.id, :website_id => 2)
        
        models = Model.where(:make_id => make.id)
        models.each do |model|
          @compare_model = CompareModel.where(:model_id => model.id, :website_id => 2)
          if !@compare_model.blank?
            @year = [1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014]
            @year.each do |year|
              begin
                autoplaza(URI.encode("http://autos-usados.autoplaza.com.mx/Autos/SearchResultPage.aspx?IsFql=False&Query=&AdditionalQuery=&Offset=0&MaxHits=9999&Filter:marca=#{@compare_make[0].value}&Filter:modelo=#{@compare_model[0].value}&Filter:year=#{year}&Filter:estado=#{@compare_state[0].value}"),make.id,model.id,state.id,year)
                @array.concat @autoplaza
              rescue OpenURI::HTTPError => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ECONNREFUSED => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ECONNRESET => exc
                puts "ERROR: #{exc.message}"
              rescue Timeout::Error => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ETIMEDOUT => exc
                puts "ERROR: #{exc.message}"
              end
            end
          end
        end
      end 
    end

    @array.each do |data|
      Advert.create(
        :image => data[0]["image"],
        :title => data[0]["title"],
        :url => data[0]["url"],
        :price => data[0]["price"],
        :location => data[0]["location"],
        :phone => data[0]["phone"],
        :comment => data[0]["comment"],
        :color => data[0]["color"],
        :km => data[0]["km"],
        :make => data[0]["make"],
        :model => data[0]["model"],
        :state => data[0]["state"],
        :year => data[0]["year"])
    end
  end
    
  def get_autocompro
    @array = []
    states = State.where(:country_id => 2)
    states.each do |state|
      puts state.name
      #autocompro
      @compare_state = CompareState.where(:state_id => state.id, :website_id => 3)
      makes = Make.all
      makes.each do |make|
        @compare_make = CompareMake.where(:make_id => make.id, :website_id => 3)
        
        models = Model.where(:make_id => make.id)
        models.each do |model|
          @compare_model = CompareModel.where(:model_id => model.id, :website_id => 3)
          if !@compare_model.blank?
            @year = [1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014]
            @year.each do |year|
              begin
                autocompro(URI.encode("http://autocom.pro/results?&estado=#{@compare_state[0].value}&maid=#{@compare_make[0].value}&moid=#{@compare_model[0].value}&limitstart=0&limit=9999&minyear=#{year}&maxyear=#{year}"),make.id,model.id,state.id,year)   
                @array.concat @autocompro
              rescue OpenURI::HTTPError => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ECONNREFUSED => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ECONNRESET => exc
                puts "ERROR: #{exc.message}"
              rescue Timeout::Error => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ETIMEDOUT => exc
                puts "ERROR: #{exc.message}"
              end
            end
          end
        end
      end
    end
    
    @array.each do |data|
      Advert.create(
        :image => data[0]["image"],
        :title => data[0]["title"],
        :url => data[0]["url"],
        :price => data[0]["price"],
        :location => data[0]["location"],
        :phone => data[0]["phone"],
        :comment => data[0]["comment"],
        :color => data[0]["color"],
        :km => data[0]["km"],
        :make => data[0]["make"],
        :model => data[0]["model"],
        :state => data[0]["state"],
        :year => data[0]["year"])
    end
  end
    
  def get_mercadolibre
    @array = []
    states = State.where(:country_id => 2).limit(5).offset(5)
    states.each do |state|
      
      #mercadolibre
      @compare_state = CompareState.where(:state_id => state.id, :website_id => 4)
      makes = Make.where(:id => 4).limit(1)
      makes.each do |make|
        @compare_make = CompareMake.where(:make_id => make.id, :website_id => 4)
        
        models = Model.where(:make_id => make.id).limit(1)
        models.each do |model|
          @compare_model = CompareModel.where(:model_id => model.id, :website_id => 4)
          if !@compare_model.blank?
            @year = [1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014]
            @year.each do |year|
              begin
                mercadolibre(URI.encode("http://autos.mercadolibre.com.mx/#{@compare_make[0].value}/#{@compare_model[0].value}/#{@compare_state[0].value}_YearRange_#{year}-#{year}"),make.id,model.id,state.id,year)  
                @array.concat @mercadolibre
              rescue OpenURI::HTTPError => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ECONNREFUSED => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ECONNRESET => exc
                puts "ERROR: #{exc.message}"
              rescue Timeout::Error => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ETIMEDOUT => exc
                puts "ERROR: #{exc.message}"
              end
            end
          end
        end
      end
    end
    
    @array.each do |data|
      Advert.create(
        :image => data[0]["image"],
        :title => data[0]["title"],
        :url => data[0]["url"],
        :price => data[0]["price"],
        :location => data[0]["location"],
        :phone => data[0]["phone"],
        :comment => data[0]["comment"],
        :color => data[0]["color"],
        :km => data[0]["km"],
        :make => data[0]["make"],
        :model => data[0]["model"],
        :state => data[0]["state"],
        :year => data[0]["year"])
    end
  end
    
  def get_seminuevossonora
    @array = []
      #seminuevossonora
      makes = Make.where(:id => 4).limit(1)
      makes.each do |make|
        @compare_make = CompareMake.where(:make_id => make.id, :website_id => 5)
        
        models = Model.where(:make_id => make.id).limit(1)
        models.each do |model|
          @compare_model = CompareModel.where(:model_id => model.id, :website_id => 5)
          if !@compare_model.blank?
            @year = [1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014]
            @year.each do |year|
              begin
                seminuevossonora(URI.encode("http://seminuevossonora.com/autos?order=field_precio_amount&sort=desc&s=1&buscar=#{@compare_model[0].value}&a1=#{year}&a2=#{year}"),make.id,model.id,26,year)
                @array.concat @seminuevossonora
              rescue OpenURI::HTTPError => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ECONNREFUSED => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ECONNRESET => exc
                puts "ERROR: #{exc.message}"
              rescue Timeout::Error => exc
                puts "ERROR: #{exc.message}"
              rescue Errno::ETIMEDOUT => exc
                puts "ERROR: #{exc.message}"
              end
            end
          end
        end
    end
    
    @array.each do |data|
      Advert.create(
        :image => data[0]["image"],
        :title => data[0]["title"],
        :url => data[0]["url"],
        :price => data[0]["price"],
        :location => data[0]["location"],
        :phone => data[0]["phone"],
        :comment => data[0]["comment"],
        :color => data[0]["color"],
        :km => data[0]["km"],
        :make => data[0]["make"],
        :model => data[0]["model"],
        :state => data[0]["state"],
        :year => data[0]["year"])
    end
  end
  
    module_function :get_autoplaza, :get_soloautos, :get_autocompro, :get_mercadolibre, :get_seminuevossonora
end