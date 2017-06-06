class LtePack < ActiveRecord::Base
	self.table_name = "lte_packing"
	establish_connection :Lte
end