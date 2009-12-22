require 'rubygems'
require 'yaml'
require 'open-uri'

class Absorb
  
  
  def initialize(name)
    @filename = name 
  end

  def gets
  
  end

  def puts()
    hash = YAML.load(@filename,'w')
     
  end

  def reputs
  
  end

  def gets_key 
  
  end

  def gets_value(key)
  
  end


end

