class TUser < ActiveRecord::Base

	self.table_name = "t_users"
	establish_connection :typo

	has_secure_password

	before_create :generate_authentication_token

 	def generate_authentication_token
 	    loop do
 	    	self.authentication_token = SecureRandom.base64(64)
 	    	break if !TUser.find_by(authentication_token: authentication_token)
 	    end
 	end

 	def reset_auth_token
	    generate_authentication_token
	    save
	end
end