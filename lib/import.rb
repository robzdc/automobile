# encoding: UTF-8
module ImportsDB
	#autoplaza = 2   //string
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
      @existe = CompareState.where("state_id = ? AND website_id = ?",row.id,2)
      if @existe.empty?
        value = row.name.strip.split(" ").join("-")
        compare = CompareState.new(:state_id => row.id, :website_id => 2, :value => value)
        compare.save
        puts value
      end
    end
  end
  
end