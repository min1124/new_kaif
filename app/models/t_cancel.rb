class TCancel < ActiveRecord::Base
	self.table_name = "t_cancel"
	establish_connection :typo

	validates_uniqueness_of  :fnumber,conditions: ->{where('flag = ?',nil)} ,:message =>"该单据已维护" 
end