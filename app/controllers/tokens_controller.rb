class TokensController < ApplicationController

require 'digest/sha1'

	def get

		if params[ :echostr].nil?
			
			xml = params[ :xml]

			host = xml[ :ToUserName]
			user = xml[ :FromUserName]
			time = xml[ :CreateTime]
			content = xml[ :Content]
			type = xml[ :MsgType]

			builder = Builder::XmlMarkup.new
  			xml = builder.xml{ |b|  
  				b.ToUserName(user); 
  				b.FromUserName(host); 
  				b.CreateTime(Time.now.to_i);
  				b.MsgType("text");
  				b.Content("hello")
  				}


			#data = {:ToUserName => user, :FromUserName => host , :CreateTime => Time.now.to_i , :MsgType => "text" , :Content => "hello" }.to_xml

			render :xml => xml
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
