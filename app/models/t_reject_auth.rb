class T_Reject_Auth < ActiveRecord::Base
	self.table_name = "t_reject_auth"
	establish_connection :typo

	def null
		self.create_auth = ""
		self.delete_auth = ""
		self.dept_auth = ""
		self.fz_auth = ""
		self.cgy_auth = ""
		self.export_auth = ""
		self.save
	end
end