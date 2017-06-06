class Tbox < ActiveRecord::Base
	# set_primary_key = "FItemID"
	self.table_name = "t_tabbox"
	establish_connection :typo
end