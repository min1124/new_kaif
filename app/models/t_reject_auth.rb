class T_Reject_Auth < ActiveRecord::Base
	self.table_name = "t_reject_auth"
	establish_connection :typo

	def null
		self.create_auth = ""
		self.delete_auth = ""
		self.dept_auth = ""
		self.me_gx_auth = ""
		self.me_qj_auth = ""
		self.me_mk_auth = ""
		self.me_to_auth = ""
		self.pz_gx_auth = ""
		self.pz_qj_auth = ""
		self.pz_mk_auth = ""
		self.pz_to_auth = ""
		self.fz_auth = ""
		self.cgy_auth = ""
		self.export_auth = ""
		self.save
	end
end