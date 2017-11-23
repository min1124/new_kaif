class SessionController < ApplicationController
	#skip_before_action :verify_authenticity_token
  	def index
  		render :json =>session
    end
    
    def create
        
        @user = TUser.find_by_name(params[:name])
        if @user && @user.authenticate(params[:password])
         # self.current_user = @user
        
         # self.current_user = @user
         # render :text => "1"
        else
           render :text => "0"
        end
    end
    
    def destory
       @user = TUser.find_by_work_no(params[:work_no])
       @user.reset_auth_token
    end
end
