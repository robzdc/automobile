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
        #imagen.set_attribute('height', '120')  
        imagen['src'] = imagen['src'].gsub('-100-', '-640-')
       
        @image =  imagen['src'].to_s
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
    
  end
  
  # soloautos.com
  def soloautos(site)
    
    res = Net::HTTP.get_response(URI.parse(site))
    
    if res.code != 200
      @error500 = true
    end
    
		
    doc = Nokogiri::HTML(open(site))
    
    
    #initialize variables
    @soloautos = []
    
    #verify if return 0 results
    if doc.css(".left.w560.lh130.mt10.gray.br10.b.t13.tc.pd10.gris-obscuro").length > 0
      @noresults = true
    end
    
    if !@noresults
      doc.css('.resultado').each do |auto|
        
        #get image
        auto.css('.img_res').each do |imagen|
          if !imagen['src'].include? 'http'
            imagen['src'] = 'http://autos-usados.soloautos.com.mx/'+imagen['src']   
          end
          #imagen.set_attribute('height', '120')  
          #big image 
          #imagen['src'].gsub('tn_', '')
          
          @image =  imagen['src'].to_s
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
        #imagen.set_attribute('height', '120')  
        #imagen['src'] = imagen['src']
       
        @image =  imagen['src'].to_s
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
          'km' => @km
          ]
      end  
      
    end
    
  end
  
end