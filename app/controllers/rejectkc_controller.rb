class RejectkcController < ApplicationController
    before_action :authentication, only: [:index, :zzd,:Rejection,:sh,:t_RejectionEntry,:t_Rejection,:dept,:delete]
	def index
        if power(T_K3_Auth, "t_rejectkc_auth")
    		starttime = params[:starttime]
    		endtime = params[:endtime]
            djzt = params[:djzt]
            bfjecx = params[:bfjecx]
            bflbcx = params[:bflbcx]
            bfbmcx = params[:bfbmcx]
            sqlDjzt = "";
            if djzt&&(""!=djzt)
                case djzt
                    when "模块生产部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "器件生产部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "TO生产部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "管芯生产部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "生产管理部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "管芯技术部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "公共研发部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "开发工程部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "高速产品线"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "数通产品线"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "SFP产品线"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "PON产品线"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "成都研发部"
                        sqlDjzt += " and 部门 = '"+djzt+"' and 报废单状态 = '待部门负责人审核'";
                    when "待ME负责人审核"
                        sqlDjzt += " and 报废单状态 = '"+djzt+"'";
                    when "待品质负责人审核"
                        sqlDjzt += " and 报废单状态 = '"+djzt+"'";
                    when "待生管负责人审核"
                        sqlDjzt += " and 报废单状态 = '"+djzt+"'";
                    when "待财务负责人审核"
                        sqlDjzt += " and 报废单状态 = '"+djzt+"'";
                    when "待分管副总审核"
                        sqlDjzt += " and 报废单状态 = '"+djzt+"'";
                    when "待仓管员审核"
                        sqlDjzt += " and 报废单状态 = '"+djzt+"'";
                    when "已审核完成"
                        sqlDjzt += " and 报废单状态 = '"+djzt+"'";
                    when "已终止"
                        sqlDjzt += " and 报废单状态 = '"+djzt+"'";
                end
            end

            if bfjecx&&(""!=bfjecx)
                case bfjecx
                    when "≤3000"
                        sqlDjzt += " and 报废金额 <= 3000"
                    when ">3000"
                        sqlDjzt += " and 报废金额 > 3000"
                end
            end

            if bflbcx&&(""!=bflbcx)&&("all"!=bflbcx)
                sqlDjzt += " and 报废类别 = '"+bflbcx+"'";
            end

            if bfbmcx&&(""!=bfbmcx)&&("all"!=bfbmcx)
                sqlDjzt += " and 部门 like '"+bfbmcx+"%'";
            end
            
    		if endtime&&starttime&&(""!=endtime)&&(""!=starttime)
    			@a=ActiveRecord::Base.connection.select_all("select * from v_RejctionKc 
                    where convert(varchar(10),日期,120) >= '"+starttime+"' 
                    and convert(varchar(10),日期,120) <='"+endtime+"'" + sqlDjzt)
    			render :json =>{:data =>@a}
    		else
    			@a=ActiveRecord::Base.connection.select_all("select * from v_RejctionKc 
                    where 日期 > dateadd(week,-1,getdate())" + sqlDjzt)
    			render :json =>{:data =>@a}
    		end
        else
            return nopower!
        end
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
		inputs=params[:inputs]
		djlx=params[:djlx]
		bflx=params[:bflx]
        bflb=params[:bflb]
		rq=params[:rq]
		djbh=params[:djbh]
		bmbz=params[:bmbz]
		zzdh=params[:zzdh]
		cpdm=params[:cpdm]
		cpmc=params[:cpmc]
		zzsl=params[:zzsl]
        ck=params[:ck]

        today = Time.new
        rejDate = today.strftime("%Y-%m-%d %H:%M:%S")

        sqlInsert1 = "insert into t_RejctionKc(FBillNo,FBillClass,FProBillNo,FNumber,FName,FProducQty,
                    FRejKind,FRejClass,FBillMaker,FDate,FDeptNo,FCk) 
                    values('"+djbh+"','"+djlx+"','"+zzdh+"','"+cpdm+"','"+cpmc+"','"+zzsl+"',
                    '"+bflx+"','"+bflb+"','"+@user.name+"','"+rq+"',
                    '"+bmbz+"','"+ck+"')";

        sqlInsert2 = "insert into t_RejectionEntryKc(FBillNoEntry,FEntryNumber,FEntryName,
                    FRejQty,FRejReason) ";
        sql = "";
        bfjetotal = 0;

        if "成品报废"==bflb
            if !zzsl||""==zzsl
                zzsl = 0;
            end
            if zzsl.to_f < "0".to_f
                bfsl = 0;
            else 
                bfsl = zzsl.to_f;
            end
            
            if ""!=cpdm 
                if bfsl != 0
                    bfjetotal = getBfdj(bflb,bfsl,cpdm);
                    if "false_more" == bfjetotal
                        render :text =>"产品代码#{cpdm}存在多个报废单价，请核实！"
                    elsif "false_nil" == bfjetotal
                        render :text =>"产品代码#{cpdm}的报废单价未维护！"
                    else
                        sqlInsert3 = "insert into t_RejCheckFluKc(FRejBillNo,RejAmount_1,RejDate,Status) values('"+djbh+"','"+bfjetotal.to_s+"','"+rejDate+"',0)";
                        a = inputs.length/4
                        if bmbz==@user.dept&&power(T_Rejectkc_Auth, "create_auth")
                            ActiveRecord::Base.transaction do
                                for i in 0..a-1
                                    sql = " select '"+djbh+"','"+inputs[0+i*4]+"',
                                        '"+inputs[1+i*4]+"','"+inputs[2+i*4]+"','"+inputs[3+i*4]+"' union all";
                                    sqlInsert2 += sql;    
                                end
                                if sql
                                    conn.insert(sqlInsert2[0,sqlInsert2.length-9]); 
                                    conn.insert(sqlInsert1);
                                    conn.insert(sqlInsert3);                
                                end
                            end
                            render :text =>"保存成功"
                        else
                            render :text =>"保存失败"
                        end
                    end
                else
                    render :text =>"报废数量小于或等于0！"
                end
            else
                render :text =>"产品代码为空！"
            end            
        end

        if "原材料报废"==bflb
            a = inputs.length/4
            if bmbz==@user.dept&&power(T_Rejectkc_Auth, "create_auth")
                flag = true;
                
                for i in 0..a-1
                    bfsl = 0;
                    if ""!=inputs[0+i*4]
                        wldm = inputs[0+i*4]
                        if ""==inputs[2+i*4]
                            render :text =>"报废数量为空！"
                            flag = false;
                            break;
                        elsif inputs[2+i*4].to_f <= 0
                            render :text =>"报废数量小于0！"
                            flag = false;
                            break;
                        else 
                            bfsl = inputs[2+i*4].to_f;
                            if "false_more" == getBfdj(bflb,bfsl,wldm)
                                render :text =>"物料代码#{wldm}存在多个报废单价，请核实！"
                                flag = false;
                                break;
                            elsif "false_nil" == getBfdj(bflb,bfsl,wldm)
                                render :text =>"物料代码#{wldm}的报废单价未维护！"
                                flag = false;
                                break;
                            else
                                bfjetotal += getBfdj(bflb,bfsl,wldm);
                                sql = " select '"+djbh+"','"+inputs[0+i*4]+"',
                                    '"+inputs[1+i*4]+"','"+inputs[2+i*4]+"','"+inputs[3+i*4]+"' union all";
                                sqlInsert2 += sql; 
                            end
                        end
                    else
                        render :text =>"物料代码为空！"
                        flag = false;
                        break;
                    end             
                end

                if sql&&flag
                    ActiveRecord::Base.transaction do
                        conn.insert(sqlInsert2[0,sqlInsert2.length-9]); 
                        conn.insert(sqlInsert1);
                        sqlInsert3 = "insert into t_RejCheckFluKc(FRejBillNo,RejAmount_1,RejDate,Status) values('" + djbh + "','" + bfjetotal.to_s + "','"+rejDate+"',0)";
                        conn.insert(sqlInsert3);  
                    end
                    render :text =>"保存成功"              
                end
                
            else
                render :text =>"保存失败"
            end        
        end
	end

    def getBfdj(bflb,bfsl,dm)
        @a = Bfdjprice.new
        @a = Bfdjprice.find_by_sql("select * from bfdjprice where FEntryNumber = '"+dm+"' and FRejClass = '"+bflb+"'")
        if nil != @a && @a.length > 0
            if @a.length == 1
                bfdj = @a[0].RejAmountDJ
                return bfdj*bfsl
            else
                return "false_more"
            end
        else 
            return "false_nil"
        end
    end

	def t_RejectionEntry
		sql = params[:sql]
		@a = ActiveRecord::Base.connection.select_all("select * from t_RejectionEntryKc where FBillNoEntry = '"+sql+"'")
		render :json =>{:data =>@a}
	end
	def t_Rejection
		sql = params[:sql]
		@a = ActiveRecord::Base.connection.select_all("select 单据编号,单据类别,制单人,批号,产品代码,产品名称,数量,日期,部门,报废类型,报废类别,报废单状态,仓库 from v_RejctionKc where 单据编号 = '"+sql+"'")
		@b = ActiveRecord::Base.connection.select_all("select * from v_RejCheckFluKc where FRejBillNo = '"+sql+"'")
		render :json =>{:data1 =>@a,:data2 =>@b}
	end
    def dept
        deptYearMonth=params[:deptYearMonth]
		@b = ActiveRecord::Base.connection.select_value "select convert(varchar,max(convert(numeric(18,0),substring(fbillno,3,len(fbillno))))) from t_RejctionKc where fbillno like '"+deptYearMonth+"%' "     
	    render :text => @b 
    end
    def de
    	@b = ActiveRecord::Base.connection.select_all("select FItemID,FName 
            from t_Department where FDeleted = 0 and FParentID in (504,508) ")
		render :json =>{:data =>@b}
    end
    def ck
        @b = ActiveRecord::Base.connection.select_all("select fItemID,fName from t_stock 
            where FTypeID=500 and FDeleted=0")
        render :json =>{:data =>@b}
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
                today = Time.new
                rejDeptDate = today.strftime("%Y-%m-%d %H:%M:%S")

                djbhInsOrUpd = conn.select_value("select FRejBillNo from t_RejCheckFluKc where FRejBillNo = '"+djbh+"'");
                if djbhInsOrUpd&&(""!=djbhInsOrUpd)
                    a="update t_RejCheckFluKc set RejDeptManager = '"+@user.name+"' , RejDeptDate = '"+rejDeptDate+"' , Status = 1 where FRejBillNo = '"+djbh+"'"
                    if conn.update(a)
                        render :text => "审核成功"
                    else
                        render :text => "审核失败"
                    end
                else
                    a="insert into t_RejCheckFluKc (FRejBillNo,RejDeptManager,RejDate,rejDeptDate,Status) values('"+djbh+"','"+@user.name+"','"+rejDeptDate+"','"+rejDeptDate+"',1)"
                    if conn.insert(a)
                        render :text => "审核失败"
                    else
                        render :text => "审核成功"
                    end
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
                        pzSh(@user.name, params[:note], djbh, "pz_gx_auth")
                    when "器件生产部"
                        pzSh(@user.name, params[:note], djbh, "pz_qj_auth")
                    when "模块生产部"
                        pzSh(@user.name, params[:note], djbh, "pz_mk_auth")
                    when "TO生产部"
                        pzSh(@user.name, params[:note], djbh, "pz_to_auth")
                    when "生产管理部"
                        pzSh(@user.name, params[:note], djbh, "pz_sg_auth")
                    when "管芯技术部"
                        pzSh(@user.name, params[:note], djbh, "pz_gj_auth")
                    when "开发工程部"
                        pzSh(@user.name, params[:note], djbh, "pz_kf_auth")
                    when "公共研发部"
                        pzSh(@user.name, params[:note], djbh, "pz_gy_auth")
                    when "高速产品线"
                        pzSh(@user.name, params[:note], djbh, "pz_gs_auth")
                    when "数通产品线"
                        pzSh(@user.name, params[:note], djbh, "pz_st_auth")
                    when "SFP产品线"
                        pzSh(@user.name, params[:note], djbh, "pz_sf_auth")
                    when "PON产品线"
                        pzSh(@user.name, params[:note], djbh, "pz_po_auth")
                    when "成都研发部"
                        pzSh(@user.name, params[:note], djbh, "pz_cy_auth")
                end
    		else
    			return nopower!
    		end
        when "sg"
            today = Time.new
            proDate = today.strftime("%Y-%m-%d %H:%M:%S")

            if power(T_Rejectkc_Auth, "sg_auth")
                a="update t_RejCheckFluKc set ProManager = '"+@user.name+"',ProManagerNote = '"+params[:note]+"', ProDate = '"+proDate+"', Status = 4 where FRejBillNo = '"+djbh+"'"
                if conn.update(a)
                    render :text => "审核成功"
                else
                    render :text => "审核失败"
                end
            else
                return nopower!
            end
    	when "cw"
    		if power(T_Rejectkc_Auth, "cw_auth")

                today = Time.new
                finDate = today.strftime("%Y-%m-%d %H:%M:%S")

    			a="update t_RejCheckFluKc set FinManager = '"+@user.name+"',FinManagerNote = '"+params[:note]+"',RejAmount_1 = '"+params[:fin]+"', FinDate = '"+finDate+"', Status = 5 where FRejBillNo = '"+djbh+"'"
    			if conn.update(a)
                    render :text => "审核成功"
                else
                    render :text => "审核失败"
                end
    		else
    			return nopower!
    		end
    	when "fgfz"
    		if power(T_Rejectkc_Auth, "fz_auth")

                today = Time.new
                viseDate = today.strftime("%Y-%m-%d %H:%M:%S")

    			a="update t_RejCheckFluKc set ViseManager = '"+@user.name+"',ViseManagerNote = '"+params[:note]+"', ViseDate = '"+viseDate+"', Status = 6 where FRejBillNo = '"+djbh+"'"
    			if conn.update(a)
                    render :text => "审核成功"
                else
                    render :text => "审核失败"
                end
    		else
    			return nopower!
    		end   		
    	when "ck"
    		if power(T_Rejectkc_Auth, "cgy_auth")

                today = Time.new
                warehouseDate = today.strftime("%Y-%m-%d %H:%M:%S")

    			a="update t_RejCheckFluKc set WarehouseAdmin = '"+@user.name+"', WarehouseDate = '"+warehouseDate+"', Status = 7 where FRejBillNo = '"+djbh+"'"
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

    def gb
        name=params[:name]
        @user = TUser.find_by_name(name)
        dept = params[:dept]
        conn = ActiveRecord::Base.connection()
        sql = conn.select_value("select FName from t_Department where FItemID ="+@user.dept);
        djbh = params[:djbh]
        type = params[:type]
        case type
        when "me"
            if "制造工程部"==sql
                case dept
                    when "管芯生产部"
                        functionGb(djbh, "me_gx_auth")
                    when "器件生产部"
                        functionGb(djbh, "me_qj_auth")
                    when "模块生产部"
                        functionGb(djbh, "me_mk_auth")
                    when "TO生产部"
                        functionGb(djbh, "me_to_auth")
                    when "管芯技术部"
                        functionGb(djbh, "me_gj_auth")
                    when "生产管理部"
                        functionGb(djbh, "me_sg_auth")
                    when "开发工程部"
                        functionGb(djbh, "me_kf_auth")
                    when "公共研发部"
                        functionGb(djbh, "me_gy_auth")
                    when "高速产品线"
                        functionGb(djbh, "me_gs_auth")
                    when "数通产品线"
                        functionGb(djbh, "me_st_auth")
                    when "SFP产品线"
                        functionGb(djbh, "me_sf_auth")
                    when "PON产品线"
                        functionGb(djbh, "me_po_auth")
                    when "成都研发部"
                        functionGb(djbh, "me_cy_auth")
                end
            else
                return nopower!
            end
        when "pz"
            if "品质部"==sql
                case dept
                    when "管芯生产部"
                        functionGb(djbh, "pz_gx_auth")
                    when "器件生产部"
                        functionGb(djbh, "pz_qj_auth")
                    when "模块生产部"
                        functionGb(djbh, "pz_mk_auth")
                    when "TO生产部"
                        functionGb(djbh, "pz_to_auth")
                    when "生产管理部"
                        functionGb(djbh, "pz_sg_auth")
                    when "管芯技术部"
                        functionGb(djbh, "pz_gj_auth")
                    when "开发工程部"
                        functionGb(djbh, "pz_kf_auth")
                    when "公共研发部"
                        functionGb(djbh, "pz_gy_auth")
                    when "高速产品线"
                        functionGb(djbh, "pz_gs_auth")
                    when "数通产品线"
                        functionGb(djbh, "pz_st_auth")
                    when "SFP产品线"
                        functionGb(djbh, "pz_sf_auth")
                    when "PON产品线"
                        functionGb(djbh, "pz_po_auth")
                    when "成都研发部"
                        functionGb(djbh, "pz_cy_auth")
                end
            else
                return nopower!
            end
        when "sg"
            functionGb(djbh, "sg_auth")
        when "cw"
            functionGb(djbh, "cw_auth")
        when "fgfz"
            functionGb(djbh, "fz_auth")      
        when "ck"
            functionGb(djbh, "cgy_auth")
        end     
    end

  	def delete
        conn = ActiveRecord::Base.connection()
  		djbh=params[:djbh]
        if power(T_Rejectkc_Auth, "delete_auth")
            a="update t_RejctionKc set FDeletFlag = 1 where FBillNo ='"+djbh+"'"
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
        sql = "select * from v_RejctionKc where (报废单状态 <> '"+status+"' or 报废金额 >3000) and 单据编号 in ("+fbillno+")";
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
            sql = "update t_RejCheckFluKc set ProManager = '"+@user.name+"',ProManagerNote = '"+params[:sgyj]+"', ProDate = '"+proDate+"', Status = 4 where FRejBillNo in ("+fbillno+")";
            if conn.update(sql)
                render :text => "审核成功"
            else
                render :text => "审核失败"
            end
        else
            return nopower!
        end     
    end

    def cwPlshQx #财务权限
        if power(T_Rejectkc_Auth, "cw_auth")
            render :text => 0
        else
            return nopower!
        end
    end

    def cwPlsh
        name = params[:name]
        @user = TUser.find_by_name(name)
        if power(T_Rejectkc_Auth, "cw_auth")
            fbillno = params[:fbillno]

            today = Time.new
            finDate = today.strftime("%Y-%m-%d %H:%M:%S")

            conn = ActiveRecord::Base.connection()
            sql = "update t_RejCheckFluKc set FinManager = '"+@user.name+"',FinManagerNote = '"+params[:cwyj]+"', FinDate = '"+finDate+"', Status = 5 where FRejBillNo in ("+fbillno+")";
            if conn.update(sql)
                render :text => "审核成功"
            else
                render :text => "审核失败"
            end
        else
            return nopower!
        end     
    end

    def fgfzPlshQx #分管副总权限
        if power(T_Rejectkc_Auth, "fz_auth")
            render :text => 0
        else
            return nopower!
        end
    end

    def plsh
        name = params[:name]
        @user = TUser.find_by_name(name)
        if power(T_Rejectkc_Auth, "fz_auth")
            fbillno = params[:fbillno]

            today = Time.new
            viseDate = today.strftime("%Y-%m-%d %H:%M:%S")

            conn = ActiveRecord::Base.connection()
            sql = "update t_RejCheckFluKc set ViseManager = '"+@user.name+"',ViseManagerNote = '"+params[:fgfzyj]+"', ViseDate = '"+viseDate+"', Status = 6 where FRejBillNo in ("+fbillno+")";
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
            a="update t_RejCheckFluKc set MEManager = '"+meManager+"',MEManagerNote = '"+meManagerNote+"',MeDate = '"+meDate+"',Status = 2 where FRejBillNo = '"+djbh+"'"
            if conn.update(a)
                render :text => "审核成功"
            else
                render :text => "审核失败"
            end
        else
            return nopower!
        end
    end

    def pzSh(qltManager, qltManagerNote, djbh, auth)
        today = Time.new
        qltDate = today.strftime("%Y-%m-%d %H:%M:%S")
        if power(T_Rejectkc_Auth, auth)
            conn = ActiveRecord::Base.connection()
            a="update t_RejCheckFluKc set QltManager = '"+qltManager+"',QltManagerNote = '"+qltManagerNote+"', QltDate = '"+qltDate+"',Status = 3 where FRejBillNo = '"+djbh+"'"
            if conn.update(a)
                render :text => "审核成功"
            else
                render :text => "审核失败"
            end
        else
            return nopower!
        end
    end

    def functionGb(djbh, auth)
        conn = ActiveRecord::Base.connection()
        if power(T_Rejectkc_Auth, auth)
            a="update t_RejCheckFluKc set Status = 99 where FRejBillNo = '"+djbh+"'"
            if conn.update(a)
                render :text => "终止成功"
            else
                render :text => "终止失败"
            end
        else
            return nopower!
        end
    end
end