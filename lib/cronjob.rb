#!/usr/bin/env ruby

require "./scraping_job_v2.rb"

require 'parallel'

first_run = (1..11).to_a
second_run = (12..23).to_a
third_run = (24..35).to_a
fourth_run = (36..47).to_a
fifth_run = (48..59).to_a

results = Parallel.each(first_run, :in_processes=>2){|i| 
  ActiveRecord::Base.connection.reconnect!
  Scraping::get_soloautos(i)
  Scraping::get_autoplaza(i)
}

results2 = Parallel.each(second_run, :in_processes=>2){|i|
  ActiveRecord::Base.connection.reconnect!
  Scraping::get_soloautos(i)
  Scraping::get_autoplaza(i)
}

results3 = Parallel.each(third_run, :in_processes=>2){|i| 
  ActiveRecord::Base.connection.reconnect!
  Scraping::get_soloautos(i)
  Scraping::get_autoplaza(i)
}

results3 = Parallel.each(fourth_run, :in_processes=>2){|i| 
  ActiveRecord::Base.connection.reconnect!
  Scraping::get_soloautos(i)
  Scraping::get_autoplaza(i)
}

results3 = Parallel.each(fifth_run, :in_processes=>2){|i| 
  ActiveRecord::Base.connection.reconnect!
  Scraping::get_soloautos(i)
  Scraping::get_autoplaza(i)
}
  
