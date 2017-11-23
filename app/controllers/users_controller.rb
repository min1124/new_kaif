class UsersController < ApplicationController
	# before_action :require_user, only: [:index, :create]
	def usernew   #人员新增页面
		@user=TDomitUser.new
	end

	def index   #人员列表页面
		#@users=TDomitUser.all
		@users=TDomitUser.find_by_sql("select *from View_User order by id")
		#render :json =>@users
		render :json =>{:data => @users}
		# render :json =>session
	end

	def search
		# sql = params[:sql]
		# sql2=sql[sql.index(' '),sql.length]

		@users=TDomitUser.find_by_sql("select *from View_User where "+sql)
		#render :json =>@users
		render :json =>{:data => @users}
	end

	def create  #添加人员信息
		@user=TDomitUser.new(user_params)
		@user.state=1
		# if @auser.length!=0		
  #  			render :text =>"信息已存在"
		# else
		if @user.save
        	render :text =>"1"
    	else
    		# render :text =>"0"
        	render :text =>@user.errors.values
    	end
		# end
        
	end

	def edit   #人员修改页面
       @user = TDomitUser.find(params[:id])
       #render :json =>@user
       render :json =>{:data => @user}
	end
	
	def update #修改人员信息
	    @user = TDomitUser.find(params[:id])
	    if @user.update(user_params)
	        render :text => "1"
        else
            render :text =>"0"
        end
	end
	
	def power
		require 'fileutils'
		if File.exist?("../K3/log/development.log")
			text = ''
			file = File.open("../K3/log/development.log")  
			file.each_line{|line| text = text + line +"<br/>"}  
			file.close();  
			render :text => text
		else
			render :text => '文件不存在'
		end
	end

	def delete
		@user = TDomitUser.find(params[:id])
		@domitrecord = TDomitRecord.where("id_no=? and checkinfo=?",@user.id_no,1)
		if @domitrecord.length!=0	
			if @user.destory
				render :text => "1"
			else
				render :text => "删除失败"
			end
		else
			render :text =>"请先退房!"
		end 
	end

	private
    def user_params
    	#params.require(:user).permit(:name,:work_no,:id_no,:email,:gender,:birthday,:adress,:age,:dept_no)
        params.permit(:name,:work_no,:id_no,:email,:gender,:birthday,:adress,:age,:dept_no)
    end
end
