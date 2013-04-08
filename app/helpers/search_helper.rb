module SearchHelper
  def range
    @range = Array.new
    (10000..1000000).step(10000).each {|x|
      @range << [number_to_currency(x,:unit => "$"), x]
    }
    return @range
  end
end
