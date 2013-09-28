#!/usr/bin/env ruby
# encoding: UTF-8

require File.expand_path('../test_helper', __FILE__)

# --  Test for bug when it loads with no frames

class ExecTest < Test::Unit::TestCase
  def test_being_able_to_run_its_binary
    Dir.chdir(File.dirname(__FILE__)) do
      assert system(OS.ruby_bin + " ruby-prof-bin do_nothing.rb")
    end
  end
end
