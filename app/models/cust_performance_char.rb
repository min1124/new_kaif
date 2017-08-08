class Cust_Performance_Char < ActiveRecord::Base
	self.table_name = "cust_performance_char"
	establish_connection :typo
end