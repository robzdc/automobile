# encoding: UTF-8
require 'securerandom' 

module SemiNuevos
	
  ############################
  # Image                    #
  # Title										 #
  # URL										   #
  # Price										 #
  # Location								 #
  # Phone										 #
  # Comments								 #
  # Color								 		 #
  # Km								 		   #
  # Year                     #
  ############################

  # soloautos.com
  def soloautos(site)
     
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
        
        if !@noresults
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
              @km = km.content.strip.to_s
            end 
            
            if !@image.nil?  #create only array with data
              @soloautos << [
                'id' => SecureRandom.hex,
                'image' => @image,
                'title' => @title, 
                'url' => "#{@href}", 
                'price' => @price, 
                'location' => @location,
                'phone' => @phone,
                'comment' => @comment,
                'color' => '',
                'km' => @km
              ]
            end  
          end
        end
      end  #while
    end 
  end
    
  # autoplaza.com
    def autoplaza(site,price1,price2,year1,year2)
   
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
        @title = titulo.content
        @href = titulo['href']
      end
      
      #get URL
      auto.css('.descriptCar a').each do |url|
        @href = url['href']
      end
      
      #get price 
      auto.css('.precio').each do |precio|
        price = precio.content
        note=precio.search("br")
        note.remove()
        
        price.slice! "$"
        price.slice! "M.N."
       
        @price = price.strip.delete(',').to_i
       
        @saltar = false
        
        if (!price1.blank? && @price < price1.to_i)
          @saltar = true
        end
        if (!price2.blank? && @price > price2.to_i)
          @saltar = true
        end
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
        @km = km.content.strip.to_s
      end
      
      #get year
      auto.css('.descriptCar a h2').each do |year|
        year = year.content.split(" ").last
        
        @year = year.to_i
       
        @saltar2 = false
        if (!year1.blank? && @year < year1.to_i)
          @saltar2 = true
        end
        if (!year2.blank? && @year > year2.to_i)
          @saltar2 = true
        end
      end
     
      if (!@image.nil? && !@saltar && !@saltar2)  #create only array with data
     		@autoplaza << [
          'image' => @image,
          'title' => @title, 
          'url' => 'http://www.autos-usados.autoplaza.com.mx/Autos/' + @href, 
          'price' => @price, 
          'location' => @location,
          'phone' => '',
          'comment' => @comment,
          'color' => '',
          'km' => @km
        ]
      end
 		
    end 
    
  end
  
  # autocom.pro
  def autocompro(site)
    doc = Nokogiri::HTML(open(site))
    
    #initialize variables
    @autocompro = []
    
    doc.css('#products-list tr.alt:not(.border)').each do |auto|
      #get image
      auto.css('td .rel-thumb a img').each do |imagen|
        imagen = imagen['src'].to_s
        
        @image =  imagen
        
        #image big
        imagen.slice! "th/"
        @image_big = imagen
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
          'id' => SecureRandom.hex,
          'image' => @image,
          'image_big' => @image_big,
          'title' => @title, 
          'url' => "http://autocom.pro/#{@href}", 
          'price' => @price, 
          'location' => @location,
          'phone' => '',
          'comment' => @comment,
          'color' => @color,
          'km' => @km
          ]
      end  
      
    end
    
  end
    
  # mercadolibre.com
  def mercadolibre(site)
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
            'id' => SecureRandom.hex,
            'image' => @image,
            'image_big' => '',
            'title' => @title, 
            'url' => @href, 
            'price' => @price, 
            'location' => @location,
            'phone' => @phone,
            'comment' => '',
            'color' => '',
            'km' => @km
            ]
        end
       
      end
      #sum 51 results
      @page = @page+50
    end

  end
    
  #seminuevossonora.com
  def seminuevossonora(site)
    @encontro_datos = true 
    @page = 0
    
    #initialize variables
    @seminuevossonora = []
    
    while @encontro_datos do   #While site have results, request url
      
      doc = Nokogiri::HTML(open(site+"&page=#{@page}"))
      puts @page
      if doc.search('.pager .pager-last').length == 0
        @encontro_datos = false
      end
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
            'id' => SecureRandom.hex,
            'image' => @image,
            'image_big' => '',
            'title' => @title, 
            'url' => @href, 
            'price' => @price, 
            'location' => '',
            'phone' => '',
            'comment' => '',
            'color' => '',
            'km' => ''
            ]
        end
        
      end
      #sum 51 results
      @page = @page+1
    end
  end    
  
end