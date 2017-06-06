class T_Hj_Auth < ActiveRecord::Base
	self.table_name = "t_hj_auth"
	establish_connection :typo

	def null
		self.export_auth = ""
		self.save
	end
end