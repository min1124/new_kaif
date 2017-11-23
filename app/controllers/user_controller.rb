class UserController < ApplicationController
	def index
		@user=TUser.select(:name,:work_no,:dept,:flag,:id).all
		render :json =>{:data => @user}
	end

	def edit
		name = params[:name_1]
		@user = TUser.select(:name,:work_no,:dept,:flag,:id).find_by_name(name)
		@K3 = T_K3_Auth.find_by_name(name)
		@icmo = T_Icmo_Auth.find_by_name(name)
		@receive = T_Receive_Auth.find_by_name(name)
		@reject = T_Reject_Auth.find_by_name(name)
		@rejectyf = T_Rejectyf_Auth.find_by_name(name)
		@rejectkc = T_Rejectkc_Auth.find_by_name(name)
		@bom = T_Bom_Auth.find_by_name(name)
		@hj = T_Hj_Auth.find_by_name(name)
		@change = T_Change_Auth.find_by_name(name)
		@fnumber = T_Fnumber_Auth.find_by_name(name)
		@fnquery = T_Fnquery_Auth.find_by_name(name)
		@fnupdate = T_Fnupdate_Auth.find_by_name(name)
		render :json =>{:user =>@user, :k3 =>@K3, :icmo =>@icmo, :receive =>@receive, 
			:reject =>@reject, :rejectyf =>@rejectyf, :rejectkc =>@rejectkc, 
			:bom =>@bom, :hj =>@hj, :change => @change, :fnumber => @fnumber, 
			:fnquery => @fnquery, :fnupdate => @fnupdate}
	end

	def update_power
		k3 = params[:k3]
		recieve = params[:recieve]
		reject = params[:reject]
		rejectyf = params[:rejectyf]
		rejectkc = params[:rejectkc]
		icmo = params[:icmo]
		bom = params[:bom]
		hj = params[:hj]
		change = params[:change]
		fnumber = params[:fnumber]
		fnquery = params[:fnquery]
		fnupdate = params[:fnupdate]
		ActiveRecord::Base.transaction do
			auth(T_K3_Auth,k3)
			auth(T_Reject_Auth,reject)
			auth(T_Rejectyf_Auth,rejectyf)
			auth(T_Rejectkc_Auth,rejectkc)
			auth(T_Icmo_Auth,icmo)
			auth(T_Receive_Auth,recieve)
			auth(T_Bom_Auth,bom)
			auth(T_Hj_Auth,hj)
			auth(T_Change_Auth,change)
			auth(T_Fnumber_Auth,fnumber)
			auth(T_Fnquery_Auth,fnquery)
			auth(T_Fnupdate_Auth,fnupdate)
			@user = TUser.find_by_name(params[:name])
			@user.power_flag = 0
			@user.save
		end
		render :text => '1'
	end

	def update_power2
		k3 = params[:k3]
		recieve = params[:recieve]
		reject = params[:reject]
		icmo = params[:icmo]
		bom = params[:bom]
		hj = params[:hj]
		change = params[:change]
		fnumber = params[:fnumber]
		fnquery = params[:fnquery]
		fnupdate = params[:fnupdate]
		ActiveRecord::Base.transaction do
			auth(T_K3_Auth,k3)
			auth(T_Reject_Auth,reject)
			auth(T_Icmo_Auth,icmo)
			auth(T_Receive_Auth,recieve)
			auth(T_Bom_Auth,bom)
			auth(T_Hj_Auth,hj)
			auth(T_Change_Auth,change)
			auth(T_Fnumber_Auth,fnumber)
			auth(T_Fnquery_Auth,change)
			auth(T_Fnupdate_Auth,fnupdate)
			@user = TUser.find_by_name(params[:name])
			@user.power_flag = 1
			@user.save
		end
		render :text => '申请成功'
	end

	def update_user
		name = params[:name]
		newpsw = params[:newpsw]
		@user = TUser.find_by_name(name)
		@user.work_no = params[:work_no]
		@user.dept = params[:dept]
		@user.flag = params[:flag]
		if newpsw
			@user.password = newpsw
			if @user.save
        		render :text => "修改密码成功"
        	else
        		render :text => "修改密码失败"
        	end
		else
			@user.save 
			render :text => '修改信息成功'
		end
		# render :json => @user
	end

	def update_pwd
		password_new = params[:password_new]
		@user = TUser.find_by_name(params[:name])
        if @user && @user.authenticate(params[:password])
        	@user.password = password_new
        	@user.save
        	render :text => "1"
        else
           render :text => "0"
        end
	end

	def pswupdate
    	name = params[:name]
    	oldpsw = params[:oldpsw]
    	newpsw = params[:newpsw]
    	@user = TUser.find_by_name(name)
        if @user && @user.authenticate(oldpsw)
        	@user.password = newpsw
        	if @user.save
        		render :text => "修改密码成功"
        	else
        		render :text => "修改密码失败"
        	end
        else
        	render :text => "用户名或密码错误"
        end
    end

    def plm
    	type = params[:type]
    	option = params[:option]
    	case type
    	when "to"
    		@a = TO.find_by_sql("select * from t_to where 类别 ='"+option+"'")
    		render :json => {:data =>@a}
    	when "qj"
    		@a = TO.all#find_by_sql("select * from t_to where ID >50")
    		render :json => {:data =>@a}
    	when "mk"
    		@a = TO.all#find_by_sql("select * from t_to where ID >50")
    		render :json => {:data =>@a}
    	when "bc"
    		@a = TO.all#find_by_sql("select * from t_to where ID >50")
    		render :json => {:data =>@a}
    	end	
    end
end



