# encoding: UTF-8
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
  ############################
  # autoplaza.com
  def autoplaza(site)
   
    doc = Nokogiri::HTML(open(site))
    
    #initialize variables
    @autoplaza = []

    doc.css('#resultList li').each do |auto|
      
      #get image
      auto.css('.contPic a img').each do |imagen|
        imagen.set_attribute('height', '120')  
        imagen['src'] = imagen['src'].gsub('-100-', '-640-')
       
        @image =  imagen.to_s
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
      
      if !@image.nil?  #create only array with data
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
    
    #order data
    #@seminuevos = @seminuevos.sort_by {|precio|  
      #precio[0]['price'] 
    #}
    
  end
  
  # soloautos.com
  def soloautos(site)
    doc = Nokogiri::HTML(open(site))
    
    #initialize variables
    @soloautos = []
    
    doc.css('.resultado').each do |auto|
      
      #get image
      auto.css('.img_res').each do |imagen|
        if !imagen['src'].include? 'http'
          imagen['src'] = 'http://autos-usados.soloautos.com.mx/'+imagen['src']   
        end
				imagen.set_attribute('height', '120')  
        #big image 
        #imagen['src'].gsub('tn_', '')
        
        @image =  imagen.to_s
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
          'image' => @image,
          'title' => @title, 
          'url' => "http://autos-usados.soloautos.com.mx/#{@href}", 
          'price' => @price, 
          'location' => @location,
          'phone' => @phone,
          'comment' => @comment,
          'color' => '',
          'km' => @km
        ]
      end
      
      #order data
     # @soloautos = @soloautos.sort_by {|precio|  
     #   precio[0]['price'] 
     # }
      
    end
    
  end
  
end