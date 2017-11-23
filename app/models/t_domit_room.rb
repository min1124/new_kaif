class TDomitRoom < ActiveRecord::Base
	# def inter
	# 	Connection.execute("")
	# end
	#validates :room_no, uniqueness: true 

	validates_uniqueness_of  :room_no, scope: :domit_no ,:message =>"房间号已存在"  
	validates_presence_of  :room_no ,:message =>"房间号不为空" 
	validates_presence_of :bed_count,:message =>"床位数不为空"

end
