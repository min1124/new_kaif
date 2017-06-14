class IcmoController < ApplicationController
	before_action :authentication, only: [:index, :PPBom_Entry,:PPBom_Main,:review]
	def index
		starttime = params[:starttime]
		endtime = params[:endtime]
		zzdh = params[:zzdh]
		type = params[:type]
		view = "v_PPBomList"
		
		if power(T_K3_Auth, "t_icmo_auth")
			if endtime&&starttime
				if(endtime==""||starttime=="")
					if zzdh==""
						@a = ActiveRecord::Base.connection.select_all("select 制造单号,产品代码,生产车间,制造数量,SN号,产品名称,产品要求,制单人,包装要求,批号,工程师,品质工程师,日期,计划开工日期,计划完工日期,配料时间 from "+view+" where 日期>dateadd(month,-1,getdate())")#.force_encoding("UTF-8")
						render :json =>{:data => @a}
					else
						@a=ActiveRecord::Base.connection.select_all("select 制造单号,产品代码,生产车间,制造数量,SN号,产品名称,产品要求,制单人,包装要求,批号,工程师,品质工程师,日期,计划开工日期,计划完工日期,配料时间 from "+view+" where 制造单号 like '%"+zzdh+"%'")
						render :json =>{:data => @a}
					end
				else
					@a=ActiveRecord::Base.connection.select_all("select 制造单号,产品代码,生产车间,制造数量,SN号,产品名称,产品要求,制单人,包装要求,批号,工程师,品质工程师,日期,计划开工日期,计划完工日期,配料时间 from "+view+" where 制造单号 like '%"+zzdh+"%' and  日期 >='"+starttime+"' and 日期 <='"+endtime+"'")
					render :json =>{:data => @a}
				end
			else
				render :json =>{:data =>ActiveRecord::Base.connection.select_all("select 制造单号,产品代码,生产车间,制造数量,SN号,产品名称,产品要求,制单人,包装要求,批号,工程师,品质工程师,日期,计划开工日期,计划完工日期,配料时间 from "+view+" where 日期>dateadd(month,-1,getdate())")}	
			end		
		else
			return nopower!
		end		
	end
	def PPBom_Entry
		sql = params[:sql]
		type = params[:type]
		if type=="icmo"
			proc = "PPBom_Entry"
		else
			if type=="sub"
				proc ="OutPPBom_Entry"
			else
			end
		end
		if power(T_K3_Auth, "t_icmo_auth")
			@a = ActiveRecord::Base.connection.select_all("exec "+proc+ "'"+sql+"'")
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end
	def PPBom_Main
		sql = params[:sql]
		type = params[:type]
		if type=="icmo"
			proc = "PPBom_Main"
		else
			if type=="sub"
				proc ="OutPPBom_Main"
			else
			end
		end
		if power(T_K3_Auth, "t_icmo_auth")
			@a = ActiveRecord::Base.connection.select_all("exec "+proc+ "'"+sql+"'")
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end
	def review
		conn = ActiveRecord::Base.connection()
		fnumber=params[:FNumber]
		name=params[:name]
		fbillno=params[:FBillNo]
		type=params[:type]#区分是生产任务制造单还是投料单审核
		stype = params[:stype]#区分是工程师审核还是品质工程师审核
		setname1="FHeadSelfY0235 = '"+name
		setname2="FHeadSelfY0239 = '"+name
		a=fnumber[0..1]
		case stype
		when "gcs"
			case a
			when "02"
				if power(T_Icmo_Auth, "ic_auth")
					if conn.update(set(setname1,fbillno,type))
						render :text => "0"
					else
						render :text => "1"
					end
				else
					return nopower!
				end
			when "03"
				if power(T_Icmo_Auth, "to_auth")
					if conn.update(set(setname2,fbillno,type))
						render :text => "0"
					else
						render :text => "1"
					end
				else
					return nopower!
				end
			when "04"
				if power(T_Icmo_Auth, "device_auth")
					if conn.update(set(setname1,fbillno,type))
						render :text => "0"
					else
						render :text => "1"
					end
				else
					return nopower!
				end
			when "05"
				if power(T_Icmo_Auth, "module_auth")
					if conn.update(set(setname1,fbillno,type))
						render :text => "0"
					else
						render :text => "1"
					end
				else
					return nopower!
				end
			else
				render :text => '此单据不予审核'
			end
			
		when "pzgcs"
			if power(T_Icmo_Auth, "quality_auth")
				# sql="select * from [dbo].[v_PPBomList]  where 制造单号 ='"+fbillno+"' and 工程师 is not null"
				# if ActiveRecord::Base.connection.select_all(sql)[0]
					if conn.update(set(setname2,fbillno,type))
						render :text => "0"
					else
						render :text => "1"
					end
				# else
				# 	render :text => "1"
				# end
			else
				return nopower!
			end
			
		else
			render :text =>0
		end
						
	end

	def sub
		starttime = params[:starttime]
		endtime = params[:endtime]
		if power(T_K3_Auth, "t_icmo_auth")
			if starttime&&endtime
				@a = ActiveRecord::Base.connection.select_all("select * from v_OutPPBomList where 日期>'"+starttime+"' and 日期 <'"+endtime+"'")
				render :json => {:data => @a}
			else
				@a = ActiveRecord::Base.connection.select_all("select * from v_OutPPBomList where 日期>dateadd(month,-1,getdate())")
				render :json => {:data => @a}
			end
		else
			return nopower!
		end
	end

	private
	def set(name,fbillno,type)
		if type == 'icmo'
			sql = "update PPBom set "+name+"' from PPBom a join ICMO b on a.FICMOInterID = b.FInterID where b.FBillNo = '"+fbillno+"'"
		else
			if type == 'sub'
				sql = "update PPBom set " +name+ "' from PPBom a join v_IC_PPBOM1007381 b on a.FInterID = b.FID where b.FICMOInterIDNumber = '" +fbillno+ "'"
			else
			end
		end
		return sql
	end
end