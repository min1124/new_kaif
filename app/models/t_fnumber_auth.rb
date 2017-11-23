class T_Fnumber_Auth < ActiveRecord::Base
	self.table_name = "t_fnumber_auth"
	establish_connection :typo

	def null
		self.t_fnquery_auth = ""
		self.t_fnupdate_auth = ""
		self.save
	end
end