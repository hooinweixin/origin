#encoding: utf-8

class ApiTest
	def self.test_url 
		"http://127.0.0.1:3000/"
	end

	def self.get
		connection = Faraday.new( :url => test_url )
		#response = connection.post( "/tokens/get", {:signature => "abae9e65900515726a9aff67e260272d2cb34430" , :timestamp => "sdafdsv" , :nonce => "adasdhoiahf" , :echostr=>"abcdefg"}).body

		response = connection.post( "/tokens/get", {:xml =>{:ToUserName=>"gh_2828429115a6", :FromUserName =>"obEFBt836gy8shmado2cSiUnUT38", :CreateTime =>"1409054359", :MsgType =>"text", :Content =>"llllll", :MsgId=>"6051842390391712861"}, :signature=>"7caaaa231505a6a58b05c854c9901106d0415712", :timestamp=>"1409054359", :nonce=>"2042217141"}).body


		puts response
	end
end


