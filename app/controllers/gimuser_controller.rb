class GimuserController < ApplicationController
	def index
		@gimuser=TUser.all

		#render :json =>@gimuser
		#@domituser=TDomitRoom.all
		#json.room @domituser, :id, :room_no, :bed_count, :room_type

		# json.user do	
  		# 	json.id @gimuser.id
		# 	json.work_no @gimuser.work_no
		# 	json.password @gimuser.password_digest    
		# end
	end

	def new   #人员新增页面
		@user=TUser.new
	end
	def create
         @user=TUser.new(user_params)

         if @user.save 
             render :text => "1"
         else
             render :text => "0"
         end
       # render :text => "0"
    end

    private
    def user_params
        params.permit(:name,:password,:dept,:work_no)
    end
end
 
