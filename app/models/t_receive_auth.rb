class T_Receive_Auth < ActiveRecord::Base
	self.table_name = "t_receive_auth"
	establish_connection :typo

	def null
		self.export = ""
		self.update_wharehouse = ""
		self.update_sale = ""
		self.save
	end
end