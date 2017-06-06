class T_Change_Auth < ActiveRecord::Base
	self.table_name = "t_change_auth"
	establish_connection :typo

	def null
		self.ic_auth = ""
		self.to_auth = ""
		self.device_auth = ""
		self.module_auth = ""
		self.quality_auth = ""
		self.save
	end
end