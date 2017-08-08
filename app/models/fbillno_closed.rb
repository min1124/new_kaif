class Fbillno_Closed < ActiveRecord::Base
	self.table_name = "f_billno_closed"
	establish_connection :typo
end