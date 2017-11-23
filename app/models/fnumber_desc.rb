class Fnumber_Desc < ActiveRecord::Base
	self.table_name = "fnumber_desc"
	establish_connection :typo
end