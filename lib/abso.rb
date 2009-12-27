require 'rubygems'
require 'yaml'
require 'open-uri'

class Absorb
  
  
  def initialize(name)
    @filename = name
    File.open(name,"w").close unless File.exist?(name)   
    @hash = {}
  end


  def set_key(array)
   array.each{|data|
    @hash[data] ||= 0
   }
  end

  def set_value(name,value)
    @hash[name] = value
  end


  def gets
     
  end

  def puts
  end

  def puts_a
  
  end

  def gets_key 
  
  end

  def gets_value(key)
  
  end


end

