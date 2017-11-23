class RetrieveController < ApplicationController
    before_action :authentication, only: [:index, :zzd,:Rejection,:sh,:t_RejectionEntry,:t_Rejection,:dept,:delete]
	def index
        if power(T_K3_Auth, "t_rejectkc_auth")
    		starttime = params[:starttime]
    		endtime = params[:endtime]
            djzt = params[:djzt]
            bfbmcx = params[:bfbmcx]
            clyjcx = params[:clyjcx]
            sqlDjzt = "";
            if djzt&&(""!=djzt)
                case djzt
                    when "模块生产部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "器件生产部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "TO生产部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "管芯生产部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "生产管理部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "管芯技术部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "公共研发部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "开发工程部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "高速产品线"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "数通产品线"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "SFP产品线"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "PON产品线"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "成都研发部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 状态 = '待部门负责人审核'";
                    when "待ME负责人审核"
                        sqlDjzt += " and 状态 = '"+djzt+"'";
                    when "待品质负责人审核"
                        sqlDjzt += " and 状态 = '"+djzt+"'";
                    when "待生管负责人审核"
                        sqlDjzt += " and 状态 = '"+djzt+"'";
                    when "已审核完成"
                        sqlDjzt += " and 状态 = '"+djzt+"'";
                end
            end

            if bfbmcx&&(""!=bfbmcx)&&("all"!=bfbmcx)
                sqlDjzt += " and 部门 like '"+bfbmcx+"%'";
            end

            if clyjcx&&(""!=clyjcx)&&("all"!=clyjcx)
                if "other"==clyjcx
                    sqlDjzt += " and 处理意见 <> '退货'";
                else
                    sqlDjzt += " and 处理意见 = '"+clyjcx+"'";
                end
            end
            
    		if endtime&&starttime&&(""!=endtime)&&(""!=starttime)
    			@retrieve=ActiveRecord::Base.connection.select_all("select * from V_Retrieve 
                    where convert(varchar(10),日期,120) >= '"+starttime+"' 
                    and convert(varchar(10),日期,120) <='"+endtime+"'" + sqlDjzt);
    			render :json => {:data =>@retrieve}
    		else
    			@retrieve=ActiveRecord::Base.connection.select_all("select * from V_Retrieve 
                    where 日期 > dateadd(week,-1,getdate())" + sqlDjzt);
    			render :json => {:data =>@retrieve}
    		end
        else
            return nopower!
        end
	end

    def de
        @b = ActiveRecord::Base.connection.select_all("select FItemID,FName 
            from t_Department where FDeleted = 0 and FParentID in (504,508) ")
        render :json =>{:data =>@b}
    end

    def dept
        deptYearMonth=params[:deptYearMonth]
        @b = ActiveRecord::Base.connection.select_value "select convert(varchar,max(convert(numeric(18,0),substring(fbillno,3,len(fbillno))))) from Retrieve where fbillno like '"+deptYearMonth+"%' "     
        render :text => @b 
    end

    def zzd
        sql = params[:sql]
        @a = ActiveRecord::Base.connection.select_all("exec PR_RejInfo "+ "'"+sql+"'")
        render :json =>{:data =>@a}
    end

	def cpdm
		sql = params[:sql]
		@a = ActiveRecord::Base.connection.select_all("SELECT FNumber AS 产品代码, FName AS 产品名称
                FROM t_ICItem WHERE FDeleted = 0 and FNumber = '"+sql+"'")
		render :json =>{:data =>@a}
	end

	def Rejection
        conn = ActiveRecord::Base.connection()
		name=params[:name]
		@user = TUser.find_by_name(name)

        bmbz=params[:bmbz]
        djbh=params[:djbh]
        rq=params[:rq]
        zzdh=params[:zzdh]
        cpdm=params[:cpdm]
        cpmc=params[:cpmc]
        zzsl=params[:zzsl]
        ph=params[:ph]
        bhgfnumber=params[:bhgfnumber]
        bhgfname=params[:bhgfname]
        bhgsl=params[:bhgsl]
        bhgxx=params[:bhgxx]
        today = Time.new
        date = today.strftime("%Y-%m-%d %H:%M:%S")
        sqlInsert1 = "insert into Retrieve(FBillNo,FProBillNo,FNumber,FName,FProducQty,
                    FDeptNo,FGMPBatchNo,FNumberN,FNameN,FQtyN,FRejReason,FBillMaker,
                    FStartTime,Status) 
                    values('"+djbh+"','"+zzdh+"','"+cpdm+"','"+cpmc+"','"+zzsl+"',
                    '"+bmbz+"','"+ph+"','"+bhgfnumber+"','"+bhgfname+"','"+bhgsl+"',
                    '"+bhgxx+"','"+@user.name+"','"+date+"',0)";
        if conn.insert(sqlInsert1)
            render :text => "保存失败";
        else 
            render :text => "保存成功";
        end
	end

	def t_RejectionEntry
		sql = params[:sql]
		@a = ActiveRecord::Base.connection.select_all("select * from t_RejectionEntryKc where FBillNoEntry = '"+sql+"'")
		render :json =>{:data =>@a}
	end

	def t_Rejection
		sql = params[:sql]
		@a = ActiveRecord::Base.connection.select_all("select * from V_Retrieve where 单据编号 = '"+sql+"'")
		render :json =>{:data =>@a}
	end
    
    def sh
    	name=params[:name]
    	@user = TUser.find_by_name(name)
    	dept = params[:dept]
    	conn = ActiveRecord::Base.connection()
    	sql = conn.select_value("select FName from t_Department where FItemID ="+@user.dept);
    	djbh = params[:djbh]
    	type = params[:type]
    	case type
    	when "bm"
    		if dept==sql&&power(T_Rejectkc_Auth, "dept_auth")
                a="update Retrieve set DeptManager = '"+@user.name+"' , 
                    DeptDate = '"+Time.new.strftime("%Y-%m-%d %H:%M:%S")+"' , 
                    Status = 1 where FBillNo = '"+djbh+"'"
                if conn.update(a)
                    render :text => "审核成功"
                else
                    render :text => "审核失败"
                end
    		else
    			return nopower!
    		end
        when "me"
            if "制造工程部"==sql
                case dept
                    when "管芯生产部"
                        meSh(@user.name, params[:note], djbh, "me_gx_auth")
                    when "器件生产部"
                        meSh(@user.name, params[:note], djbh, "me_qj_auth")
                    when "模块生产部"
                        meSh(@user.name, params[:note], djbh, "me_mk_auth")
                    when "TO生产部"
                        meSh(@user.name, params[:note], djbh, "me_to_auth")
                    when "生产管理部"
                        meSh(@user.name, params[:note], djbh, "me_sg_auth")
                    when "管芯技术部"
                        meSh(@user.name, params[:note], djbh, "me_gj_auth")
                    when "开发工程部"
                        meSh(@user.name, params[:note], djbh, "me_kf_auth")
                    when "公共研发部"
                        meSh(@user.name, params[:note], djbh, "me_gy_auth")
                    when "高速产品线"
                        meSh(@user.name, params[:note], djbh, "me_gs_auth")
                    when "数通产品线"
                        meSh(@user.name, params[:note], djbh, "me_st_auth")
                    when "SFP产品线"
                        meSh(@user.name, params[:note], djbh, "me_sf_auth")
                    when "PON产品线"
                        meSh(@user.name, params[:note], djbh, "me_po_auth")
                    when "成都研发部"
                        meSh(@user.name, params[:note], djbh, "me_cy_auth")
                end
            else
                return nopower!
            end
    	when "pz"
            if "品质部"==sql
                case dept
                    when "管芯生产部"
                        pzSh(@user.name, djbh, "pz_gx_auth")
                    when "器件生产部"
                        pzSh(@user.name, djbh, "pz_qj_auth")
                    when "模块生产部"
                        pzSh(@user.name, djbh, "pz_mk_auth")
                    when "TO生产部"
                        pzSh(@user.name, djbh, "pz_to_auth")
                    when "生产管理部"
                        pzSh(@user.name, djbh, "pz_sg_auth")
                    when "管芯技术部"
                        pzSh(@user.name, djbh, "pz_gj_auth")
                    when "开发工程部"
                        pzSh(@user.name, djbh, "pz_kf_auth")
                    when "公共研发部"
                        pzSh(@user.name, djbh, "pz_gy_auth")
                    when "高速产品线"
                        pzSh(@user.name, djbh, "pz_gs_auth")
                    when "数通产品线"
                        pzSh(@user.name, djbh, "pz_st_auth")
                    when "SFP产品线"
                        pzSh(@user.name, djbh, "pz_sf_auth")
                    when "PON产品线"
                        pzSh(@user.name, djbh, "pz_po_auth")
                    when "成都研发部"
                        pzSh(@user.name, djbh, "pz_cy_auth")
                end
    		else
    			return nopower!
    		end
        when "sg"
            today = Time.new
            proDate = today.strftime("%Y-%m-%d %H:%M:%S")
            if power(T_Rejectkc_Auth, "sg_auth")
                a="update Retrieve set ProManager = '"+@user.name+"', FProducPlace = '"+params[:note]+"', ProDate = '"+proDate+"', Status = 4 where FBillNo = '"+djbh+"'"
                if conn.update(a)
                    render :text => "审核成功"
                else
                    render :text => "审核失败"
                end
            else
                return nopower!
            end
		end		
  	end

  	def delete
        conn = ActiveRecord::Base.connection()
  		djbh=params[:djbh]
        if power(T_Rejectkc_Auth, "delete_auth")
            a="update Retrieve set FDeletFlag = 1 where FBillNo ='"+djbh+"'"
            if conn.update(a)
                render :text => "删除成功"
            else
                render :text => "删除失败"
            end
        else
            return nopower!
        end
  	end

    def plshSjJy
        name = params[:name]
        fbillno = params[:fbillno]
        status = params[:status]

        conn = ActiveRecord::Base.connection()
        sql = "select * from V_Retrieve where (状态 <> '"+status+"' or 处理意见 = '退货') and 单据编号 in ("+fbillno+")";
        @reject =  conn.update(sql)
        if nil != @reject && nil != @reject[0] && @reject[0].length > 0
            render :text => 0
        else
            render :text => 1
        end
    end

    def sgPlshQx #生管权限
        if power(T_Rejectkc_Auth, "sg_auth")
            render :text => 0
        else
            return nopower!
        end
    end

    def sgPlsh
        name = params[:name]
        @user = TUser.find_by_name(name)
        if power(T_Rejectkc_Auth, "sg_auth")
            fbillno = params[:fbillno]

            today = Time.new
            proDate = today.strftime("%Y-%m-%d %H:%M:%S")

            conn = ActiveRecord::Base.connection()
            sql = "update Retrieve set ProManager = '"+@user.name+"',FProducPlace = '"+params[:sgyj]+"', ProDate = '"+proDate+"', Status = 4 where FBillNo in ("+fbillno+")";
            if conn.update(sql)
                render :text => "审核成功"
            else
                render :text => "审核失败"
            end
        else
            return nopower!
        end     
    end

    def meSh(meManager, meManagerNote, djbh, auth)
        if power(T_Rejectkc_Auth, auth)
            today = Time.new
            meDate = today.strftime("%Y-%m-%d %H:%M:%S")

            conn = ActiveRecord::Base.connection()
            a="update Retrieve set MEManager = '"+meManager+"',FSuggestion = '"+meManagerNote+"',MeDate = '"+meDate+"',Status = 2 where FBillNo = '"+djbh+"'"
            if conn.update(a)
                render :text => "审核成功"
            else
                render :text => "审核失败"
            end
        else
            return nopower!
        end
    end

    def pzSh(qltManager, djbh, auth)
        today = Time.new
        qltDate = today.strftime("%Y-%m-%d %H:%M:%S")
        if power(T_Rejectkc_Auth, auth)
            conn = ActiveRecord::Base.connection()
            a="update Retrieve set QltManager = '"+qltManager+"', QltDate = '"+qltDate+"',Status = 3 where FBillNo = '"+djbh+"'"
            if conn.update(a)
                render :text => "审核成功"
            else
                render :text => "审核失败"
            end
        else
            return nopower!
        end
    end
end