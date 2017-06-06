class CancelgoodsController < ApplicationController
	Tltz = "SELECT a.FTranType as 单据类型,a.FNote as 退料原因,
        b.FName as 供应商名称,g.FName as 源单类型,
        a.FBillNo as 单据编号,
        k.FName as 制单,a.Fdate as 日期,
        h.FName as 审核,a.FcheckDate as 审核日期
		FROM  POInStock a 
		LEFT JOIN t_Supplier b  ON a.FSupplyID=b.FItemID AND b.FItemID<>0
		LEFT JOIN v_ICTransType g ON a.FSelTranType= g.FInterID  AND g.FInterID<>0 
		LEFT JOIN t_User k ON a.FBillerID= k.FUserID  AND k.FUserID<>0  
		LEFT JOIN t_User h ON a.FcheckerID= h.FUserID  AND h.FUserID<>0 " 
	Tltz1 = "SELECT
        n.FEntryID as 分录ID,o.FNumber as 物料代码,o.FName as 物料名称,o.FModel as 规格型号,
        n.FBatchNo as 批号,n.FQty as 数量,n.Fnote as 备注, r.FNumber as 仓库代码,r.FName as 仓库名称
		FROM  POInStock a 
		LEFT JOIN POInstockEntry n on a.FInterID = n.FInterID
		LEFT JOIN t_ICItem o ON n.FItemId= o.FItemID 
		LEFT JOIN t_Stock R on r.FItemID = n.FStockID "

	Hzwg = "SELECT a.Fdate as 日期,a.FBillNo as 单据编号,a.FTranType as 单据类型,
        d.Fname as 供应商名称,
        g.FName as 源单类型,k.FName as 制单,
        h.FName as 审核,a.FcheckDate as 审核日期
        FROM ICStockBill a
		
		LEFT JOIN t_Supplier d  ON a.FSupplyID=d.FItemID AND d.FItemID<>0
		LEFT JOIN v_ICTransType g ON a.FSelTranType= g.FInterID  AND g.FInterID<>0 
		LEFT JOIN t_User k ON a.FBillerID= k.FUserID  AND k.FUserID<>0  
		LEFT JOIN t_User h ON a.FcheckerID= h.FUserID  AND h.FUserID<>0 "
	Hzwg1 = "SELECT o.FEntryID as 分录ID,p.FNumber as 物料代码,p.FName as 物料名称,p.FModel as 规格型号,
		o.FBatchNo as 批号,o.FQtyMust as 应收数量,o.FQty as 实收数量,o.Fnote as 备注,r.FName as 仓库名称
		FROM ICStockBill a LEFT JOIN ICStockBillEntry o on a.FInterID = o.FInterID
		LEFT JOIN t_ICItem p ON o.FItemId= p.FItemID 
		LEFT JOIN t_MeasureUnit q ON o.FUnitID=q.FMeasureUnitID
		LEFT JOIN t_Stock R on r.FItemID = o.FDCStockID "

	Xchz = "SELECT a.FTranType as 单据类型,
        a.FBillNo as 单据编号,d.FName as 供应商名称,
        a.Fdate as 日期,e.FName as 源单类型,f.FName as 制单,
        i.FName as 审核,a.FcheckDate as 审核日期 
        FROM ZPStockBill a
		LEFT JOIN t_Supplier d  ON a.FSupplyID=d.FItemID AND d.FItemID<>0
		LEFT JOIN v_ICTransType  e ON a.FSelTranType= e.FInterID  AND e.FInterID<>0 
		LEFT JOIN t_User f ON a.FBillerID= f.FUserID  AND f.FUserID<>0   
		LEFT JOIN t_User i ON a.FcheckerID= i.FUserID  AND i.FUserID<>0 "
	Xchz1 = "SELECT j.FEntryID as 分录ID,k.FNumber as 物料代码,j.FQty as 数量,m.FName as 仓库名称,
        k.FName as 物料名称,k.FModel as 规格型号,j.FBatchNo as 批号,j.Fnote as 备注
        FROM ZPStockBill a
		LEFT JOIN ZPStockBillEntry j ON a.FInterID=j.FInterID
		LEFT JOIN t_ICItem k ON j.FItemId= k.FItemID 
		LEFT JOIN t_MeasureUnit l ON j.FUnitID=l.FMeasureUnitID
		LEFT JOIN t_Stock m  ON m.FItemID = j.FDCStockID "
	def index
		type = params[:type]
		case type
		when "tltz"
			sql = 'V_Tltz'
			trantype = '73'
		when "hzwg"
			sql = 'V_Hzwg'
			trantype = '1'
		when "wwhz"
			sql = 'V_Hzwg'
			trantype = '5'
		when "xchz"
			sql = 'V_Xchz'
			trantype = '6'
		end
		starttime  = params[:starttime]
		endtime =  params[:endtime]
		if starttime&&endtime
			if (endtime==""||starttime=="")
				condition1 = " WHERE 单据类型='"+trantype+"' and 日期 > dateadd(month,-3,getdate())"
			else
				condition1 = " WHERE 单据类型='"+trantype+"' and 日期 >='"+starttime+"' and 日期 <='"+endtime+"'"
			end
		else
			condition1 = " WHERE 单据类型='"+trantype+"' and 日期 > dateadd(month,-3,getdate())"
		end
		@a = TCancel.find_by_sql("select * from "+sql+ condition1)
		render :json => {:data => @a}
	end

	def fbillno
		fbillno = params[:fbillno]
		type = params[:type]
		case type
		when "tltz"
			sql = Tltz
			sql1 = Tltz1
		when "hzwg"
			sql = Hzwg
			sql1 = Hzwg1
		when "wwhz"
			sql = Hzwg
			sql1 = Hzwg1
		when "xchz"
			sql = Xchz
			sql1 = Xchz1
		end
		condition2 = "WHERE a.FBillNo = '"
		conn = ActiveRecord::Base.connection
		@main1 = conn.select_all(sql + condition2 +fbillno+"'")
		@entry = conn.select_all(sql1 + condition2 +fbillno+"'")
		@main2 = TCancel.where("fnumber = ? and flag is ?",fbillno,nil)
		render :json => {:a => @main1,:b => @entry,:c => @main2}
	end

	def del
		fbillno = params[:fbillno]
		# render :text => fbillno
		TCancel.transaction do
			for i in 0..fbillno.length-1
				cancel = TCancel.where("fnumber = ? and flag is null",fbillno[i])
				cancel[0].flag = 1
				cancel[0].save!
			end
		end
		render :text => "删除成功"
	end

	def new
        fnumber = params[:fnumber]
        hydw = params[:hydw]
        ydh =  params[:ydh]
        fhsj =  params[:fhsj]
        shsj = params[:shsj]
        shqr = params[:shqr]
        qshz = params[:qshz]
        shdh = params[:shdh]
        a = Array.new
		TCancel.transaction do
			for i in 0..fnumber.length-1
				cancel = TCancel.new
				cancel.fnumber = fnumber[i]
				cancel.hydw = hydw
				cancel.ydh = ydh
				cancel.fhsj = fhsj
				cancel.shsj = shsj
				cancel.shqr = shqr
				cancel.qshz = qshz
				cancel.shdh = shdh
				# a.push(cancel)
				begin
					cancel.save!
				rescue Exception => e
					a.push(e.record.fnumber+"单据已维护")
				end
			end
		end
		if a.length == 0
			render :text => '保存成功'
		else
			render :text => a.join(",")
		end
	end

	def stockbill
		if power(T_K3_Auth, "t_stockbill_auth")
			time = params[:time]
			now = Time.new.strftime("%Y%m")
			if time
				a = time.split('-')[0]
				b =  time.split('-')[1] 
			else
				a = now[0,4]
				b = now[4,2] 
			end
			sql = "Select  Case When a.FROB='-1' Then '红字' Else '蓝字' End As 单据类型 ,Year(a.FDate) As 年,Month(a.FDate) As 年,
	        a.FDate As 入库日期,a.FBillNo As 单据编号,d.FNumber As 物料代码,d.FName AS 物料名称 ,b.FPrice As 入库单价,b.FOrderBillNo As 订单编号,c.FPrice As 订单单价
			From ICStockBill a
			Left Join ICStockBillEntry b On a.FInterID = b.FInterID
			Left Join POOrderEntry c On b.FOrderInterID=c.FinterID And b.FOrderEntryID=c.FEntryID
			Left Join t_ICItem d on  b.FItemID=d.FItemID
			Where a.FTranType='1' And Year(a.FDate)='"+a+"' And Month(a.FDate)='"+b+"' "
			@a = ActiveRecord::Base.connection.select_all(sql)
			render :json => {:data => @a}
		else
			return nopower!
		end	
	end
end