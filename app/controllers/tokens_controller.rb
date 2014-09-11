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

			ch = Content.find_by_id(1);
			msg = ch.content + "\n" + ch.content_2 + "\n\n";

			truck = Truck.find_by_weixin(user);

			if truck.nil?

				truck = TruckOut.find_by_weixin(user);

				info = DriverInfo.find_by_truck_id(truck.id);

				workplace = Workplace.find_by_id(info.workplace_id);
			
			else

				info = TruckInfo.find_by_truck_id(truck.id);

				workplace = Workplace.find_by_id(info.start_id);
 
			end

			manager = Manager.find_by_id(info.manager_id);

			msg = msg + ch.first  + ":  " +  info.id.to_s  +  "\n"
			msg = msg + ch.second + ":  " +  truck.plate_num  +  "\n"
			msg = msg + ch.third  + ":  " +  info.created_at.to_formatted_s(:time).to_s  +  "\n"
			msg = msg + ch.fourth + ":  " +  workplace.name  +  "\n"
			msg = msg + ch.fifth  + ":  " +  manager.name  +  "\n"


			builder = Nokogiri::XML::Builder.new do |t|
  			   t.xml{
  			   	t.ToUserName(){t.cdata user}
  			    t.FromUserName(){t.cdata host}
  			    t.CreateTime Time.now.to_i.to_s 
  			    t.MsgType(){t.cdata "text"}
  			    t.Content(){t.cdata msg}
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
