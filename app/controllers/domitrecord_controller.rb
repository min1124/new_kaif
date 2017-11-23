class DomitrecordController < ApplicationController
	def index
		@domitrecord=TDomitRecord.all
		render :json =>@domitrecord
	end
	def checkin
		@domitrecord=TDomitRecord.new(room_params)
		# @domitrecord.domit_no=params[domit_no]
		# @domitrecord.id_no=params[id_no]
		# @domitrecord.room_no=params[room_no]
		# @domitrecord.bed_no=params[bed_no]
		@domitrecord.checkDate=Time.now
		@domitrecord.checkinfo=1
		if @domitrecord.save
			render :text => "1"
		else
			render :text => "0"
		end
	end

	def checkout
		@domitrecord=TDomitRecord.new(room_params)
		@domitrecord.checkDate=Time.now
		@domitrecord.checkinfo=0
		if @domitrecord.save
			render :text => "1"
		else
			render :text => "0"
		end
	end

	private
	def record_params
        params.permit(:domit_no,:id_no,:room_no,:bed_no)		
	end
end
