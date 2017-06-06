class TUser < ActiveRecord::Base

	self.table_name = "t_users"
	establish_connection :typo

	has_secure_password
end