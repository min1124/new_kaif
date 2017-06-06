class Seorder < ActiveRecord::Base
	# set_primary_key = "FItemID"
	self.table_name = "SEOrder"
	validates_uniqueness_of  :FBillNo
	# def finterid
	# 	@a = Seorder.where("FInterID = ?",self.FInterID)
	# 	if @a[0]
	# 		self.FInterID = self.FInterID+1
	# 		self.finterid
	# 	else
	# 		self.save!
	# 	end
	# end
	
	# def validate

	# end


	# def finterid
	# 	if Seorder.where("FInterID = ?",self.FInterID)
	# 		self.FInterID = self.FInterID+1
	# 		self.finterid
	# 		puts self.FInterID
	# 	else
	# 		puts self.FInterID
	# 	end
	# end
end