class Zxhub < ActiveRecord::Base
	self.table_name = "zxhub"
	establish_connection :typo
end