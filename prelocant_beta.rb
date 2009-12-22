#simple_ircbot.rb
$KCODE ='u'
require 'rubygems'
require	'pp'
require 'net/irc'
require 'twitter'
require 'mechanize'
require 'hpricot'
require 'cgi'
require 'open-uri'
require 'kconv'
require 'yaml'


class Prelocant < Net::IRC::Client


  API = "http://www.google.co.jp/search?num=3&lr=lang_ja&oe=utf-8&q="	
  def buzztter(message)
    url = "http://buzztter.com/ja"
    html = open(url).read
    doc = Hpricot(html)
    p doc
    result = doc / 'style='
    p result
    i = 0
    result.each_with_index{|div,idx|
      break if i ==4
      text = CGI.unescapeHTML(link.inner_html.gsub(/<\*>/,''))
      p test,"BUZZTTER"
      post NOTICE, @channel, text.tojis   
    }
  end 

  def google_search(message)

    #googleSearch
    word = message.toutf8.sub('pre g ','')
    url = "#{API}#{CGI.escape(word)}"
    html = open(url).read
    #p html
    doc = Hpricot(html)
    #p doc
    result = doc / 'li.g'
    puts result
    #out = []
    i = 1
    result.each_with_index{|div,idx|
      break if i==4
      next if div.attributes['style']
      link = div.at 'a'
      text = CGI.unescapeHTML(link.inner_html.gsub(%r!<b>([^<]*)</b>!) {$1})
      href = link[:href]
      out = "#{text} #{href}"
	pp out

	puts '\n' * 3
      post NOTICE, @channel, out.gsub('<em>','').gsub('</em>','').tojis
      i += 1
    }

    #ans = ""
    #out.each{|data|
    #		ans += data.to_s + " \n "       
    #		}
    #		puts ans
    #		post NOTICE, @channel,ans.gsub('<em>','').gsub('</em>','').tojis 
  end

  def incdec(message)
    File.open('incdec.yml','a').close
    file = File.open('incdec.yml','r')
    hash = YAML.load(file)
    p hash
    file.close
    if (message.index('++').to_i + 2.to_i) == message.length
      name = message.gsub('++','')
     if hash.include?(name)
      	hash[name] += 1
      else
      	hash[name] = 1
      end
      hash[name] ||= 0.to_i
      hash[name] += 1
#      post NOTICE, @channel,"#{name} => #{hash[name]}".tojis

    elsif(message.index('--').to_i + 2.to_i) == message.length 
      name = message.gsub('--','')
      if hash.include?(name)
      		hash[name] -= 1
      else
      		hash[name] = -1
      	end
      hash[name] ||= 0.to_i
      hash[name] -= 1
 #     post NOTICE, @channel,"#{name} => #{hash[name]}".tojis

    end

    file = File.open('incdec.yml','w')
    YAML.dump(hash,file)
    file.close



  end

  def karma(message)
    name = message.gsub('pre k ','')
    file = File.open('backup.yml','r')

    hash = YAML.load(file)
    #if hash[name].include?(name)
    #end
    if hash.include?(name) 
      inc = hash[name][0] 
      dec = hash[name][1]
      post NOTICE,@channel, "#{name}: #{inc-dec}(#{inc}++ #{dec}--)"  
    else
      post NOTICE,@channel, "prelocantには、まだ登録されてないよ".tojis
    end
    file.close
  end	

  def twit(message,m)
    message = message.gsub("twit ","")
    httpauth = Twitter::HTTPAuth.new("prelocant","1shi7abe")
    twit = Twitter::Base.new(httpauth)
    twit.update ("#{m.prefix.nick} : #{message}")
  end

  def flesh(message)
    name = message.gsub('flesh ','')
    post NOTICE, @channel, "http://fleshtwitter.com/search.php?select=2&v=" + name
  end

  def backup(message)
    hash ={}
    File.open('backup.yml','a').close
    file = File.open('backup.yml','r')
    hash = YAML.load(file)
    p hash
    file.close

    #hash ={}
    array = message.split(/([:+-])|(\()|(\s)/)-[""]-[" "]
                          name = array[0]
                          inc = array[array.index("(")+1].to_i
                          dec = array[array.index("(")+4].to_i
                          hash[name] = [inc,dec]
                          #data<<array[array.index("(")+1]
                          #data<<array[array.index("(")+4]
                          p hash
                          #post NOTICE,@channel, "backup #{name}: #{inc-dec}(#{inc}++ #{dec}--)".tojis  
                          file = File.open('backup.yml','w')
                          YAML.dump(hash,file)
                          file.close



  end

  def map(message)
    data = CGI.escape(message.sub('map ',''))
    url = "http://maps.google.co.jp/maps?hl=ja&q="+ data +"&lr=lang_ja&ie=UTF-8"
    post NOTICE,@channel,url.tojis
  end
  def wozozohouse
    post NOTICE,@channel,"http://maps.google.co.jp/maps?hl=ja&q=%E7%B7%B4%E9%A6%AC%E5%8C%BA%E6%A1%9C%E5%8F%B03-20-12&lr=lang_ja&ie=UTF-8".tojis
   end

  def route(message)
    word = message.gsub("route ","").sub("　"," ")
    array = word.split(" ")
    start = array[0]
    goal = array[1]
    url = "http://www.google.co.jp/maps?f=d&source=s_d&saddr=#{CGI.escape(start)}&daddr=#{CGI.escape(goal)}&hl=ja&mra=ls&dirflg=d&ie=UTF8&z=8"
    post NOTICE,@channel,url.tojis
  end

  def av(message)
    word = message.gsub("av ","")
    url = "http://www.adulttube.info/tag/p1/c/#{CGI.escape(word)}"
    puts url
    post NOTICE,@channel,url.tojis
    post NOTICE,@channel,"ふぅ".tojis
  end
  def message_func(message,m)
    #post NOTICE,@channel,'ふひひ'.tojis 
    if message[0,6]=="route "
      route(message)
    end 
    
    if message=='wozozohouse'
      wozozohouse
    end
    if message[0,6] == 'pre g '
      google_search(message)
	puts message		
     # post NOTICE,channel,'VIP'
    elsif message.include?('++') || message.include?('--')
       incdec(message)

    elsif message[0,6] == 'pre k '
      karma(message)
    end 
    if message[0,5] == 'twit '
      twit(message,m)
    end
    if message[0,6] == 'flesh '
      flesh(message)
    end
    if message[0,3] == 'av '
       puts "OKAZU"
       av(message)
    end  
    #    if m.prefix.nick == 'locant' && 0==( /\w*:\s[+-]*\d*\s[(]\d*[+]*\s\d*[-]*[)]/ =~ message)
    if  (m.prefix.nick == 'locant' || m.prefix.nick == "onodes") && 0==( /\w*:\s[+-]*\d*\s[(]\d*[+]*\s\d*[-]*[)]/ =~ message)
      backup(message)  
      #post NOTICE, @channel, "prelocant backup test"
    end 


    if message.include?('help') && message.include?('prelocant')
      post NOTICE,@channel, "g *** : google検索".tojis
      post NOTICE,@channel, 'k name : karma for **'.tojis
      post NOTICE,@channel, 'twit *** : to twitter ID:prelocant'.tojis
      post NOTICE,@channel, "flesh name: fleshtwitter's URL".tojis
    end

    if message[0,8] == 'buzztter'
      buzztter(message)
    end
    p message

    if message[0,4] == 'map '
      map(message)
    end
  end	
  def on_rpl_welcome(m)
    hash_make
    post JOIN, opts.channel
  end
  def on_message(m)
    @channel=m.params[0].to_s.toutf8
    message = m.params[1].to_s
    #message = *m.to_s
    #    if message == "pre g onodes"
    #     post NOTICE,@channel,"test"
    #   end
    puts "mmmmmmmmmmmmmmm======"
    p m.prefix.nick
    message_func(message.toutf8,m)
    #	post NOTICE,channel,'VIP'
    puts "-"*10
    p message.toutf8
    puts "-"*5
  end
end

client1 = Prelocant.new("localhost", 6668,{:nick => "prelocant", :user => "prelocant", :real => "prelocant",:channel => "#SAMIT" , :pass => "hogehoge"})


#client1 = Prelocant.new("irc.tokyo.wide.ad.jp", 6667,
#			   {:nick => "prelocantb", :user => "prelocantb", :real => "prelocantb",
#				   :channel => "#SAMIT".tojis}
#			  )


client1.start

