class T_Rejectyf_Auth < ActiveRecord::Base
	self.table_name = "t_rejectyf_auth"
	establish_connection :typo

	def null
		self.create_auth = ""
		self.delete_auth = ""
		self.dept_auth = ""
		self.pz_gj_auth = ""
		self.pz_kf_auth = ""
		self.pz_gy_auth = ""
		self.pz_gs_auth = ""
		self.pz_st_auth = ""
		self.pz_sf_auth = ""
		self.pz_po_auth = ""
		self.pz_cy_auth = ""
		self.cw_auth = ""
		self.fz_auth = ""
		self.cgy_auth = ""
		self.export_auth = ""
		self.save
	end
end