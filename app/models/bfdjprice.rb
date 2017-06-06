class Bfdjprice < ActiveRecord::Base
	self.table_name = "bfdjprice"
	establish_connection :typo
end