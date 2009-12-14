require 'rubygems'
require 'sequel'
Sequel::Model.plugin(:schema)

Sequel.connect("sqlite://events.db")
class Events < Sequel::Model
  unless table_exists?
    set_schema do
      primary_key :id
      string :title
      string :subtitle
      text  :description
      text  :time 
      integer :limit
      string  :place
      string  :address
      string  :url
      string  :option
    end 
    create_table
  end 
end 

