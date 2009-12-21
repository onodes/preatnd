require 'rubygems'
require 'sinatra'
require 'model/comment.rb'
require 'haml' 
#produced by onodes
helpers do
    include Rack::Utils; alias_method :h, :escape_html
end
 
get '/style.css' do
    content_type 'text/css', :charset => 'utf-8'
      sass :style
end
 
get '/' do
    @comments = Comments.order_by(:posted_date.desc)
      haml :index
end

get '/admin' do
  haml :admin
end



put '/comment' do
    Comments.create({
          :name => request[:name],
              :title => request[:title],
                  :message => request[:message],
                      :posted_date => Time.now,
                        })
                          redirect '/'
end
