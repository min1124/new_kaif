class T_Fnupdate_Auth < ActiveRecord::Base
	self.table_name = "t_fnupdate_auth"
	establish_connection :typo

	def null
		self.t_all_auth = ""
		self.t_gs_auth = ""
		self.t_sfp_auth = ""
		self.t_pon_auth = ""
		self.t_st_auth = ""
		self.save
	end
end