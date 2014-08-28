#encoding: utf-8
 class TokensController < ApplicationController

require 'digest/sha1'
require 'nokogiri'

	def get

		if params[ :echostr].nil?
			
  			xml = params[ :xml]

			host = xml[ :ToUserName]
			user = xml[ :FromUserName]
			time = xml[ :CreateTime]
			content = xml[ :Content]
			type = xml[ :MsgType]

			builder = Nokogiri::XML::Builder.new do |t|
  			   t.xml{
  			   	t.ToUserName(){t.cdata user}
  			    t.FromUserName(){t.cdata host}
  			    t.CreateTime Time.now.to_i.to_s 
  			    t.MsgType(){t.cdata "text"}
  			    t.Content(){t.cdata "hello"}
  			   }
			end	

			# builder = Builder::XmlMarkup.new
  	# 		xml = builder.xml{ |b|
  	# 			b.ToUserName("<<![CDATA[" + user + "]]>"); 
  	# 			b.FromUserName("<<![CDATA[" + host + "]]>"); 
  	# 			b.CreateTime("<<![CDATA[" + Time.now.to_i.to_s + "]]>");
  	# 			b.MsgType("<<![CDATA[text]]>");
  	# 			b.Content("<<![CDATA[hello]]>")
  	# 			}


			# xml = builder.xml{ |b|  
  			# 	b.ToUserName(user); 
  			# 	b.FromUserName(host); 
  			# 	b.CreateTime(Time.now.to_i.to_s);
  			# 	b.MsgType(text);
  			# 	b.Content(hello)
  			# 	}

  			
  			#puts xml
			#data = {:ToUserName => user, :FromUserName => host , :CreateTime => Time.now.to_i , :MsgType => "text" , :Content => "hello" }.to_xml

			render :xml => builder.to_xml
		else
			sign = params[ :signature]
			time = params[ :timestamp]
			nonce = params[ :nonce]
			echostr = params[ :echostr]

			token = "huyindianzishangwu"

			array = [token , time , nonce]

			array = array.sort 

			str = array[0] + array[1] + array[2]

			str = Digest::SHA1.hexdigest(str)


			#render(:text => str)
		
			if str == sign 
			    render(:text => echostr)   
				return true
			end
		end	
	end



end
