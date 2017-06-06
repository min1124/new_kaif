class Ar_Info < ActiveRecord::Base
	self.table_name = "ar_info"
	establish_connection :typo

end