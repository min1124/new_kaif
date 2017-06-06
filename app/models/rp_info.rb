class Rp_Info < ActiveRecord::Base
	self.table_name = "rp_info"
	establish_connection :typo

end