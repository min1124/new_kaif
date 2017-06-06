class TO < ActiveRecord::Base
	self.table_name = "t_to"
	establish_connection :typo
end