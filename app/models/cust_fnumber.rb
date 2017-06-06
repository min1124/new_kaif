class Cust_Fnumber < ActiveRecord::Base
	self.table_name = "cust_fnumbers"
	establish_connection :typo
end