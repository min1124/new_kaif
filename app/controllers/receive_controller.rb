class ReceiveController < ApplicationController
	before_action :authentication, only: [:search, :plgx,:hydw]
	def search
		if power(T_K3_Auth, "t_recieve_auth")#T_Receive_Auth.find_by_name(params[:name])
			conn = ActiveRecord::Base.connection()
			sql = params[:sql]
			@a=conn.select_all("select * from  v_SalesStockBill where"+sql)
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end
    
	def plgx
		if power(T_K3_Auth, "t_recieve_auth")#T_Receive_Auth.find_by_name(params[:name])
			type = params[:type]
			fbillno = params[:fbillno]
			conn = ActiveRecord::Base.connection()
			case type
			when "1"
				shdh = params[:shdh]
				sql = "update icstockbill set FHeadSelfB0172 = '"+shdh+"' where fbillno in "+fbillno+""
				if conn.update(sql)
					render :text => "0"
				else
					render :text => "1"
				end
			when "2"
				hydw = params[:hydw]
				hydh = params[:hydh]
				fhsj = params[:fhsj]
				sql = "update icstockbill set FHeadSelfB0159 = '"+hydw+"',FHeadSelfB0160 = '"+hydh+"',FHeadSelfB0171 = '"+fhsj+"' where fbillno in "+fbillno+""
				if conn.update(sql)
					render :text => "0"
				else
					render :text => "1"
				end
			when "3"
				shqrr = params[:shqrr]
				shsj = params[:shsj]
				sql = "update icstockbill set FHeadSelfB0164 = '"+shqrr+"',FHeadSelfB0173 = '"+shsj+"' where fbillno in "+fbillno+""
				if conn.update(sql)
					render :text => "0"
				else
					render :text => "1"
				end
			when "4"
				qshz = params[:qshz]
				sql = "update icstockbill set FHeadSelfB0161 = '"+qshz+"' where fbillno in "+fbillno+""
				if conn.update(sql)
					render :text => "0"
				else
					render :text => "1"
				end
			end
		else
			return nopower!
		end		
		# render :text => "sql"
	end
	def hydw
		if power(T_K3_Auth, "t_recieve_auth")#T_Receive_Auth.find_by_name(params[:name])
			@b = ActiveRecord::Base.connection.select_all("select FinterID,FName from t_submessage where FParentID = 10024  ")
			render :json =>{:data =>@b}
		else
			return nopower!
		end	
	end
end