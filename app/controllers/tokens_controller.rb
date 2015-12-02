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
			type = xml[ :MsgType]
			
			if type == "text"
			
				content = xml[ :Content]
			

				if content[0..1] == "BD"

					id = content[3..21]	

					account = Account.find_by_id_card(id);

					if account.nil? 

						msg = "您输入的身份证号不正确!"

					else

						account.weixinID =  user

			 			account.save

						msg = "微信号绑定成功!"

					end

				elsif content[0..3] == "微信绑定"
					
					msg = "请输入BD+空格+身份证号码绑定微信！"
				
				else 

					msg = "错误的消息！"
					# ch = Content.find_by_id(1);
					# msg = ch.content + "\n" + ch.content_2 + "\n\n";

					# truck = Truck.find_by_weixin(user);

					# if truck.nil?

					# 	truck = TruckOut.find_by_weixin(user);

					# 	info = DriverInfo.find_by_truck_id(truck.id);

					# 	workplace = Workplace.find_by_id(info.workplace_id);
			
					# else

					# 	info = TruckInfo.find_by_truck_id(truck.id);

					# 	workplace = Workplace.find_by_id(info.start_id);
 
					# end

					# manager = Manager.find_by_id(info.manager_id);

					# msg = msg + ch.first  + ":  " +  info.id.to_s  +  "\n"
					# msg = msg + ch.second + ":  " +  truck.plate_num  +  "\n"
					# msg = msg + ch.third  + ":  " +  info.created_at.to_formatted_s(:time).to_s  +  "\n"
					# msg = msg + ch.fourth + ":  " +  workplace.name  +  "\n"
					# msg = msg + ch.fifth  + ":  " +  manager.name  +  "\n"

				end
			
			elsif type == "event"


				event = xml[ :Event]

				if event  == "subscribe"

					msg = "欢迎关注虎印电子微信服务号！"

				elsif event == "CLICK"

					msg = "请输入BD+空格+身份证号码绑定微信！"

				end
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


			builder = Nokogiri::XML::Builder.new do |t|
  			   t.xml{
  			   	t.ToUserName(){t.cdata user}
  			    t.FromUserName(){t.cdata host}
  			    t.CreateTime Time.now.to_i.to_s 
  			    t.MsgType(){t.cdata "text"}
  			    t.Content(){t.cdata msg}
  			   }
  			 end

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


	def post

		connection = Faraday.new( :url => "https://api.weixin.qq.com/" )
		response = connection.get("cgi-bin/token?grant_type=client_credential&appid=wxb318729492ab6790&secret=1a286462ef64e8f36e9a25fc691e71e8", ).body		

		token = JSON.parse(response)["access_token"] 

		json = {
		:touser => params[ :weixinID],
		:template_id => "OPENTM202354413",
		:url => "",
		:topcolor => "#FFCA00",
		:data =>{
			:first =>  {
			:value => "装车已经成功，请使用订单号进行卸车匹配！",
			:color => "#173177"	
			},

			:keyword1 => {
			:value => params[ :plate],
			:color => "#173177"
			},
			
			:keyword2 => {
			:value => params[ :date],
			:color => "#173177"
			},

			:remark => {
			:value => "\n本短信可做为结算依据，复制转发无效",
			:color => "#173177"
			}
		}
	}.to_json	
 
		connection = Faraday.new( :url => "https://api.weixin.qq.com/" )

		response = connection.post( "/cgi-bin/message/template/send?access_token=" + token, json).body		
		puts response
		
		render :json =>{ :result => 0 }
	end


	def button

		connection = Faraday.new( :url => "https://api.weixin.qq.com/" )
		response = connection.get("cgi-bin/token?grant_type=client_credential&appid=wxb318729492ab6790&secret=1a286462ef64e8f36e9a25fc691e71e8", ).body		

		token = JSON.parse(response)["access_token"]


		json = {
			:button =>[
			{
			:type => "click",
			:name => "微信绑定",
			:key => "bd"
			}
		]
		}

		json = JSON.generate(json.as_json)

		puts json 

		connection = Faraday.new( :url => "https://api.weixin.qq.com/" )

		response = connection.post( "/cgi-bin/menu/create?access_token=" + token, json).body		
		puts response
		
		render :json =>{ :result => 0 }

	end

end
