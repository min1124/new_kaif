class Cust_Fnumber_Rec < ActiveRecord::Base
	self.table_name = "cust_fnumbers_rec"
	establish_connection :typo
end