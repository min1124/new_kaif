class TAuthority < ActiveRecord::Base
	self.table_name = "t_authority"
	establish_connection :typo
end