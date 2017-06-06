class ArrivalRate < ActiveRecord::Base
	self.table_name = "arrival_rate"
	establish_connection :typo

end