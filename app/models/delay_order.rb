class DelayOrder < ActiveRecord::Base
	self.table_name = "DelayOrder"
	establish_connection :LP
end