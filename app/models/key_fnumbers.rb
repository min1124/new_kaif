class Key_Fnumbers < ActiveRecord::Base
	self.table_name = "key_fnumbers"
	establish_connection :typo
end