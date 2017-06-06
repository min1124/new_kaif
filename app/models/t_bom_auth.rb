class T_Bom_Auth < ActiveRecord::Base
	self.table_name = "t_bom_auth"
	establish_connection :typo

	def null
		self.export_auth = ""
		self.save
	end
end