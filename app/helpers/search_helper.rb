module SearchHelper
  def range
    @range = Array.new
    (10000..1000000).step(10000).each {|x|
      @range << [number_to_currency(x,:unit => "$"), x]
    }
    return @range
  end
  
  def range_year
    @range = Array.new
    time = Time.new
    
    (1920..time.year).each {|x|
      @range << [x]
    }
    return @range.reverse
  end
end
