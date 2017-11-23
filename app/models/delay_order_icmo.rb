class DelayOrderIcmo < ActiveRecord::Base
	self.table_name = "DelayOrderWithOutICMO"
	establish_connection :LP
end