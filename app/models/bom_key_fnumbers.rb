class Bom_Key_Fnumbers < ActiveRecord::Base
	self.table_name = "bom_key_fnumbers"
	establish_connection :typo
end