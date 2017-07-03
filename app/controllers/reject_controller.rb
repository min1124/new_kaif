class RejectController < ApplicationController
    before_action :authentication, only: [:index, :zzd,:Rejection,:sh,:t_RejectionEntry,:t_Rejection,:dept,:delete]
	def index
        if power(T_K3_Auth, "t_reject_auth")#T_Reject_Auth.find_by_name(params[:name])
    		starttime = params[:starttime]
    		endtime = params[:endtime]
            djzt = params[:djzt]
            bfjecx = params[:bfjecx]
            bflbcx = params[:bflbcx]
            sqlDjzt = "";
            if djzt&&(""!=djzt)
                case djzt
                    when "模块"
                        sqlDjzt += " and 关闭标志 = 0 and 部门 like '模块%' and 报废部门负责人 is null";
                    when "器件"
                        sqlDjzt += " and 关闭标志 = 0 and 部门 like '器件%' and 报废部门负责人 is null";
                    when "TO"
                        sqlDjzt += " and 关闭标志 = 0 and 部门 like 'TO%' and 报废部门负责人 is null";
                    when "管芯"
                        sqlDjzt += " and 关闭标志 = 0 and 部门 like '管芯%' and 报废部门负责人 is null";
                    when "仓库"
                        sqlDjzt += " and 关闭标志 = 0 and 部门 like '仓库%' and 报废部门负责人 is null";
                    when "待ME负责人审核"
                        sqlDjzt += " and 关闭标志 = 0 and 报废部门负责人 is not null and ME负责人 is null";
                    when "待品质负责人审核"
                        sqlDjzt += " and 关闭标志 = 0 and ME负责人 is not null and 品质负责人 is null";
                    when "待生管负责人审核"
                        sqlDjzt += " and 关闭标志 = 0 and 品质负责人 is not null and 生产管理负责人 is null";
                    when "待财务负责人审核"
                        sqlDjzt += " and 关闭标志 = 0 and 生产管理负责人 is not null and 财务负责人 is null";
                    when "待分管副总审核"
                        sqlDjzt += " and 关闭标志 = 0 and 财务负责人 is not null and 分管副总 is null";
                    when "待仓管员确认"
                        sqlDjzt += " and 关闭标志 = 0 and 分管副总 is not null and 仓管员 is null";
                    when "已审核完成"
                        sqlDjzt += " and 关闭标志 = 0 and 仓管员 is not null";
                    when "已终止"
                        sqlDjzt += " and 关闭标志 = 1";
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

            if bflbcx&&(""!=bflbcx)
                case bflbcx
                    when "成品报废"
                        sqlDjzt += " and 报废类别 = '成品报废'";
                    when "原材料报废"
                        sqlDjzt += " and 报废类别 = '原材料报废'";
                end
            end
            
    		if endtime&&starttime&&(""!=endtime)&&(""!=starttime)
    			@a=ActiveRecord::Base.connection.select_all("select * from v_Rejction where 日期 >= '"+starttime+"' and 日期 <='"+endtime+"'" + sqlDjzt)
    			render :json =>{:data =>@a}
    		else
    			@a=ActiveRecord::Base.connection.select_all("select * from v_Rejction where 日期 > dateadd(month,-1,getdate())" + sqlDjzt)
    			render :json =>{:data =>@a}
    		end
        else
            return nopower!
        end
	end

	def zzd
		sql = params[:sql]
		@a = ActiveRecord::Base.connection.select_all("exec PR_RejInfo "+ "'"+sql+"'")
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
		rksl=params[:rksl]
		cpl=params[:cpl]

        sqlInsert1 = "insert into t_Rejction(FBillNo,FBillClass,FProBillNo,FNumber,FName,FProducQty,
                    FStockQty,FPassRate,FRejKind,FRejClass,FBillMaker,FDate,FDeptNo) 
                    values('"+djbh+"','"+djlx+"','"+zzdh+"','"+cpdm+"','"+cpmc+"','"+zzsl+"',
                    '"+rksl+"','"+cpl+"','"+bflx+"','"+bflb+"','"+@user.name+"','"+rq+"',
                    '"+bmbz+"')";

        sqlInsert2 = "insert into t_RejectionEntry(FBillNoEntry,FEntryNumber,FEntryName,
                    FRejQty,FRejReason,FNGCode,FRejKind) ";
        sql = "";
        bfjetotal = 0;

        if "成品报废"==bflb
            if !rksl||""==rksl
                rksl = 0;
            end
            if !zzsl||""==zzsl
                zzsl = 0;
            end
            if zzsl < rksl
                render :text =>"制造数量小于入库数量！"
            else 
                bfsl = zzsl.to_f - rksl.to_f;
            end
            if ""!=cpdm 
                if bfsl != 0
                    bfjetotal = getBfdj(bflb,bfsl,cpdm);
                    if "false_more" == bfjetotal
                        render :text =>"产品代码#{cpdm}存在多个报废单价，请核实！"
                    elsif "false_nil" == bfjetotal
                        render :text =>"产品代码#{cpdm}的报废单价未维护！"
                    else
                        sqlInsert3 = "insert into t_RejCheckFlu(FRejBillNo,RejAmount_1) values('"+djbh+"','"+bfjetotal.to_s+"')";
                        a = inputs.length/6
                        if bmbz==@user.dept&&power(T_Reject_Auth, "create_auth")
                            ActiveRecord::Base.transaction do
                                for i in 0..a-1
                                    sql = " select '"+djbh+"','"+inputs[0+i*6]+"',
                                        '"+inputs[1+i*6]+"','"+inputs[2+i*6]+"','"+inputs[3+i*6]+"','"+inputs[4+i*6]+"',
                                        '"+inputs[5+i*6]+"' union all";
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
            a = inputs.length/6
            if bmbz==@user.dept&&power(T_Reject_Auth, "create_auth")
                flag = true;
                
                for i in 0..a-1
                    bfsl = 0;
                    if ""!=inputs[0+i*6]
                        wldm = inputs[0+i*6]
                        if ""==inputs[2+i*6]
                            render :text =>"报废数量为空！"
                            flag = false;
                            break;
                        elsif inputs[2+i*6].to_f <= 0
                            render :text =>"报废数量小于0！"
                            flag = false;
                            break;
                        else 
                            bfsl = inputs[2+i*6].to_f;
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
                                sql = " select '"+djbh+"','"+inputs[0+i*6]+"',
                                    '"+inputs[1+i*6]+"','"+inputs[2+i*6]+"','"+inputs[3+i*6]+"','"+inputs[4+i*6]+"',
                                    '"+inputs[5+i*6]+"' union all";
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
                        sqlInsert3 = "insert into t_RejCheckFlu(FRejBillNo,RejAmount_1) values('" + djbh + "','" + bfjetotal.to_s + "')";
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
		@a = ActiveRecord::Base.connection.select_all("select * from t_RejectionEntry where FBillNoEntry = '"+sql+"'")
		render :json =>{:data =>@a}
	end
	def t_Rejection
		sql = params[:sql]
		@a = ActiveRecord::Base.connection.select_all("select 单据编号,单据类别,制单人,制造单号,产品代码,产品名称,制造单数量,入库数量,成品率,日期,部门,报废类型,报废类别,关闭标志 from v_Rejction where 单据编号 = '"+sql+"'")
		@b = ActiveRecord::Base.connection.select_all("select * from t_RejCheckFlu where FRejBillNo = '"+sql+"'")
		render :json =>{:data1 =>@a,:data2 =>@b}
	end
    def dept
        deptYearMonth=params[:deptYearMonth]
		@b = ActiveRecord::Base.connection.select_value "select convert(varchar,max(convert(numeric(18,0),substring(fbillno,3,len(fbillno))))) from t_rejction where fbillno like '"+deptYearMonth+"%' "     
	    render :text => @b 
    end
    def de
    	@b = ActiveRecord::Base.connection.select_all("select FItemID,FName from t_Department where FDeleted = 0 and FParentID in (504,508) ")
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
    		if dept==sql&&power(T_Reject_Auth, "dept_auth")
                djbhInsOrUpd = conn.select_value("select FRejBillNo from t_RejCheckFlu where FRejBillNo = '"+djbh+"'");
                if djbhInsOrUpd&&(""!=djbhInsOrUpd)
                    a="update t_RejCheckFlu set RejDeptManager = '"+@user.name+"' where FRejBillNo = '"+djbh+"'"
                    if conn.update(a)
                        render :text => "审核成功"
                    else
                        render :text => "审核失败"
                    end
                else
                    a="insert into t_RejCheckFlu (FRejBillNo,RejDeptManager) values('"+djbh+"','"+@user.name+"')"
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
                    when "器件生产一部"
                        meSh(@user.name, params[:note], djbh, "me_qj_auth")
                    when "模块生产一部"
                        meSh(@user.name, params[:note], djbh, "me_mk_auth")
                    when "TO生产部"
                        meSh(@user.name, params[:note], djbh, "me_to_auth")
                end
    		else
    			return nopower!
    		end
    	when "pz"
            if "品质部"==sql
                case dept
                    when "管芯生产部"
                        pzSh(@user.name, params[:note], djbh, "pz_gx_auth")
                    when "器件生产一部"
                        pzSh(@user.name, params[:note], djbh, "pz_qj_auth")
                    when "模块生产一部"
                        pzSh(@user.name, params[:note], djbh, "pz_mk_auth")
                    when "TO生产部"
                        pzSh(@user.name, params[:note], djbh, "pz_to_auth")
                end
    		else
    			return nopower!
    		end
    	when "sg"
    		if power(T_Reject_Auth, "sg_auth")
    			a="update t_RejCheckFlu set ProManager = '"+@user.name+"',ProManagerNote = '"+params[:note]+"' where FRejBillNo = '"+djbh+"'"
    			if conn.update(a)
                    render :text => "审核成功"
                else
                    render :text => "审核失败"
                end
    		else
    			return nopower!
    		end
    	when "cw"
    		if power(T_Reject_Auth, "cw_auth")
    			a="update t_RejCheckFlu set FinManager = '"+@user.name+"',FinManagerNote = '"+params[:note]+"',RejAmount_1 = '"+params[:fin]+"' where FRejBillNo = '"+djbh+"'"
    			if conn.update(a)
                    render :text => "审核成功"
                else
                    render :text => "审核失败"
                end
    		else
    			return nopower!
    		end
    	when "fgfz"
    		if power(T_Reject_Auth, "fz_auth")
    			a="update t_RejCheckFlu set ViseManager = '"+@user.name+"',ViseManagerNote = '"+params[:note]+"' where FRejBillNo = '"+djbh+"'"
    			if conn.update(a)
                    render :text => "审核成功"
                else
                    render :text => "审核失败"
                end
    		else
    			return nopower!
    		end   		
    	when "ck"
    		if power(T_Reject_Auth, "cgy_auth")
    			a="update t_RejCheckFlu set WarehouseAdmin = '"+@user.name+"' where FRejBillNo = '"+djbh+"'"
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
                    when "器件生产一部"
                        functionGb(djbh, "me_qj_auth")
                    when "模块生产一部"
                        functionGb(djbh, "me_mk_auth")
                    when "TO生产部"
                        functionGb(djbh, "me_to_auth")
                end
            else
                return nopower!
            end
        when "pz"
            if "品质部"==sql
                case dept
                    when "管芯生产部"
                        functionGb(djbh, "pz_gx_auth")
                    when "器件生产一部"
                        functionGb(djbh, "pz_qj_auth")
                    when "模块生产一部"
                        functionGb(djbh, "pz_mk_auth")
                    when "TO生产部"
                        functionGb(djbh, "pz_to_auth")
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
        if power(T_Reject_Auth, "delete_auth")
            a="update t_Rejction set FDeletFlag = 1 where FBillNo ='"+djbh+"'"
            if conn.update(a)
                render :text => "删除成功"
            else
                render :text => "删除失败"
            end
        else
            return nopower!
        end
  	end
	
    def plsh
        name = params[:name]
        @user = TUser.find_by_name(name)
        if power(T_Reject_Auth, "fz_auth")
            fbillno = params[:fbillno]
            conn = ActiveRecord::Base.connection()
            sql = "update t_RejCheckFlu set ViseManager = '"+@user.name+"',ViseManagerNote = '"+params[:fgfzyj]+"' where FRejBillNo in ("+fbillno+")";
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
        if power(T_Reject_Auth, auth)
            conn = ActiveRecord::Base.connection()
            a="update t_RejCheckFlu set MEManager = '"+meManager+"',MEManagerNote = '"+meManagerNote+"' where FRejBillNo = '"+djbh+"'"
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
        if power(T_Reject_Auth, auth)
            conn = ActiveRecord::Base.connection()
            a="update t_RejCheckFlu set QltManager = '"+qltManager+"',QltManagerNote = '"+qltManagerNote+"' where FRejBillNo = '"+djbh+"'"
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
        if power(T_Reject_Auth, auth)
            a="update t_Rejction set FCloseFlag = 1 where FBillNo = '"+djbh+"'"
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