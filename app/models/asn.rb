class Asn < ActiveRecord::Base
	self.table_name = "asn"
	establish_connection :typo
end