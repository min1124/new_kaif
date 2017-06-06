class Order < ActiveRecord::Base
	self.table_name = "t_order"
	establish_connection :typo
	
	validates_uniqueness_of  :po_number,scope: [:po_line_num,:request_date,:qty_request,:task_num,:flag]

	# def po_number
	# 	today = Time.new
	# 	date = today.strftime("%Y%m")[2,time.length-1]
	# end
end