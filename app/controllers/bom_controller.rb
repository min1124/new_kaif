class BomController < ApplicationController
	before_action :authentication, only: [:BOMC, :BOMP,:hj,:hjsearch]
	
	def BOMC #BOM子项物料
		if power(T_K3_Auth, "t_bom_auth")
			sql = params[:sql]
			@a = ActiveRecord::Base.connection.select_all("exec BOMQuery "+ "'"+sql+"'")
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end
	def BOMP #BOM总代码
		if power(T_K3_Auth, "t_bom_auth")
			sql = params[:sql]
			checkbox = params[:checkbox]

			if checkbox=="0"
				@b = ActiveRecord::Base.connection.select_all("exec MstockNum2 "+ "'"+sql+"'")
			else
				@b = ActiveRecord::Base.connection.select_all("exec MstockNum "+ "'"+sql+"'")
			end
			render :json =>{:data =>@b}		
		else
			return nopower!
		end
	end
	def hj #货架信息
		sql = params[:sql]
		if sql
			if power(T_K3_Auth, "t_hj_auth")
				sql = params[:sql]
				@a = ActiveRecord::Base.connection.select_all("select FNumber,FName ,FModel,F_112 from t_ICItem 
				where F_112 is not null and F_112 != '0' and FNumber like '%"+sql+"%'")
				render :json =>{:data =>@a}
			else
				return nopower!
			end
		else
			if power(T_K3_Auth, "t_hj_auth")
				@a = ActiveRecord::Base.connection.select_all("select FNumber,FName ,F_112 from t_ICItem 
				where F_112 is not null and F_112 != '0' ")
				render :json =>{:data =>@a}
			else
				return nopower!
			end
		end
	end


end
