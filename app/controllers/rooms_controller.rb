class RoomsController < ApplicationController
	def index
		#@beds=ActiveRecord::Base.connection.select_all('select *from View_Room') ; 
		@rooms=TDomitRoom.find_by_sql('select * from View_Room where room_no is not null')
 		#@beds=TDomitRoomBed.where('useflag=0')
 		render :json =>{:data => @rooms}
 		# render :json =>@rooms
	end

	def bed
		@beds=TDomitRoomBed.find_by_sql("select * from View_bed ")
		#render :json=>@beds
		render :json =>{:data => @rooms}
	end


	def edit
		@room=TDomitRoom.find(params[:id])
		#render :json =>@room
		render :json =>{:data => @room}
	end

	def create
		# @adomit=TDomitRoom.where("domit_no=? and room_no=?",params[:domit_no],params[:room_no])	
		@domit=TDomitRoom.new(room_params)
		# @domit.room_no=params[:room][:room_no]
		# @domit.bed_count=params[:room][:bed_count]
		# @domit.domit_no=params[:room][:domit_no]
		# @domit.room_type=params[:room][:room_type]
		# @domit.room_interid=@domit.id
		if @domit.save
		    for  i in 1..@domit.bed_count
		    	@bed=TDomitRoomBed.new
		    	@bed.room_interid=@domit.id
		    	@bed.bed_no=i
		    	@bed.useflag=0
		    	if @bed.save

		    	else
		    		render :json =>@bed.errors
		    	end
		    end
		    render :text => "1"
		else
		    render :text => @domit.errors.values
		end	
	end
	def search
		# sql = params[:sql]
		# sql2=sql[sql.index(' '),sql.length]
		@rooms=TDomitRoom.find_by_sql("select * from View_Room where "+sql)
		#render :json =>@rooms
		render :json =>{:data => @rooms}
	end

	def delete
		@room=TDomitRoom.find(params[:id])
		@beds=TDomitRoomBed.where("room_interid=?", @room.id)
		@beds.each do |bed|
			if bed.destroy

			else
				render :json =>bed.errors
			end
		end
		
        if @room.destroy
            render :text =>"1"
        else
            render :json =>@room.errors
        end
	    
	end
	def update
		@room=TDomitRoom.find(params[:id])
		if @room.update(room_params)
	        render :text => "1"
        else
            render :text => "0"
        end
	end

	private
    def room_params
        params.permit(:room_no,:bed_count,:domit_no,:room_type)
    end
end
