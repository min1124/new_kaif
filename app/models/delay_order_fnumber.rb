class DelayOrderFnumber < ActiveRecord::Base
	self.table_name = "DelayOrderWithOutFNumber"
	establish_connection :LP
end