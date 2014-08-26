class TokensController < ApplicationController

require 'digest/sha1'

	def get
		sign = params[ :signature]
		time = params[ :timestamp]
		nonce = params[ :nonce]

		token = "huyindianzishangwu"

		array = [token , time , nonce]

		array = array.sort 

		str = array[0] + array[1] + array[2]

		str = Digest::SHA1.hexdigest(str)

		render(:text => str)   
	end



end
