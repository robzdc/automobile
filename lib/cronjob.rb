#!/usr/bin/env ruby

#require "./scraping_job_v2.rb"
require 'parallel'
require 'open-uri'
#require 'spreadsheet'
require 'net/http'
#require 'benchmark'
#require "./scraping_one.rb"
require "./scraping_job_v2.rb"

first_run = (1..11).to_a
second_run = (12..23).to_a
third_run = (24..35).to_a
fourth_run = (36..47).to_a
fifth_run = (48..59).to_a


results = Parallel.map(first_run, :in_processes=>2){ |i|
  ActiveRecord::Base.connection.reconnect!
  Scraping::get_soloautos(i)
  Scraping::get_soloautos(i+11)
}

=begin
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
=end

