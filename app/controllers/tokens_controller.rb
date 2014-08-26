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

			render :xml => {:name => "David"}.to_xml
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
