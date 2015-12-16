#!/usr/bin/ruby

require 'gedcom'

 class Counter
  attr_reader :count
   def initialize
     @count = 0
   end

  def increment
  @count += 1
  end
 end

def count_person( data, cookie, parm )
   cookie.increment
 end
 
  counter = Counter.new
 parser = GEDCOM::Parser.new( counter )
parser.setPreHandler [ "INDI" ], method( :count_person )
  parser.parse( "db.ged" )
  puts "#{counter.count} individuals in the file"