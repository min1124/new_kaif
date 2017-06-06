class ChangeController < ApplicationController
	before_action :authentication, only:[:body,:header,:review,]
	def index
		if power(T_K3_Auth, "t_change_auth")
			conn = ActiveRecord::Base.connection()
			sql = "select
				g.fbillno as 单据编号,
				g.fbillDate as 制单日期,
				(select fname from t_User where FUserID = g.fbiller) as 制单人,
				g.MEchecker as ME审核人,
				g.QTChecker as 品质审核人,
				a.FICMOBillNo as 生产任务单号,
				b.fnumber as 物料代码,
				b.fname as 物料名称,
				c.fname as 计量单位,
				d.FBOMNumber as BOM编号,
				a.FAuxQtyPlan as 计划生产数量,
				e.FName as 生产车间,
				f.fname as 成本对象,
				a.FBatchNo as 批号,
				a.FPlanCommitDate as 计划开工日期,
				a.FPlanFinishDate as 计划完工日期,
				a.FInHighLimitQty as 完工入库上限,
				a.FInLowLimitQty as 完工入库下限,
				a.FChangeReason as 变更原因,
				a.FChangeDate as 变更日期,
				a.FNote as 备注,
				(select fname from t_User where FUserID = a.FChanger) as 变更人
				from icmochangeEntry a 
				join t_icitem b on a.FItemID = b.FItemID
				join t_MeasureUnit c on a.FUnitID = c.FMeasureUnitID
				join icbom d on a.FBOMInterID = d.FInterID
				join t_Department e on a.FWorkShop = e.FItemID
				join cbCostObj f on a.FCostObjID = f.fitemid 
				join icmochange g on a.FID = g.FID
				where g.fbillDate >= '2016-01-01'
				and g.FChecker != 0
				order by g.fbillDate desc"
			@bill = conn.select_all(sql)
			render :json  => {:data => @bill}
		else
			return nopower!
		end
	end

	def body
		if power(T_K3_Auth, "t_change_auth")
			fbillno = params[:fbillno]
			conn = ActiveRecord::Base.connection()
			sql = "select
				a.FICMOBillNo as 生产任务单号,
				b.fnumber as 物料代码,
				b.fname as 物料名称,
				c.fname as 计量单位,
				d.FBOMNumber as BOM编号,
				a.FAuxQtyPlan as 计划生产数量,
				e.FName as 生产车间,
				f.fname as 成本对象,
				a.FBatchNo as 批号,
				a.FPlanCommitDate as 计划开工日期,
				a.FPlanFinishDate as 计划完工日期,
				a.FInHighLimitQty as 完工入库上限,
				a.FInLowLimitQty as 完工入库下限,
				a.FChangeReason as 变更原因,
				a.FChangeDate as 变更日期,
				a.FNote as 备注,
				(select fname from t_User where FUserID = a.FChanger) as 变更人
				from icmochangeEntry a 
				join t_icitem b on a.FItemID = b.FItemID
				join t_MeasureUnit c on a.FUnitID = c.FMeasureUnitID
				join icbom d on a.FBOMInterID = d.FInterID
				join t_Department e on a.FWorkShop = e.FItemID
				join cbCostObj f on a.FCostObjID = f.fitemid 
				join icmochange g on a.FID = g.FID
				where g.FBillNo = '"
			@body = conn.select_all(sql+fbillno+"'")
			render :json => {:data => @body}
		else
			return nopower!
		end
	end

	def header
		if power(T_K3_Auth, "t_change_auth")
			fbillno = params[:fbillno]
			conn = ActiveRecord::Base.connection()
			sql = "select 
				a.fbillno as 单据编号,
				a.fbillDate as 制单日期,
				a.MECheckDate as ME审核日期,
				a.QTCheckDate as 品质审核日期,
				(select fname from t_User where FUserID = a.fbiller) as 制单人,
				(select fname from t_User where FUserID = a.FChecker) as 审核人,
				a.FCheckDate as 审核日期,
				a.MEchecker as ME审核人,
				a.QTChecker as 品质审核人,
				a.FID from icmochange a
				where a.fbillno = '"
			@header = conn.select_all(sql+fbillno+"'")
			render :json => @header
		else
			return nopower!
		end
	end

	def review
		fbillno = params[:fbillno]
		name = params[:name]
		type = params[:type]
		today = Time.new
		time =  today.strftime("%Y-%m-%d %H:%M:%S").to_s  

		@change = Change2.where("fbillno = ?", fbillno)
		case type
		when 'me'
			if power(T_Change_Auth, "me_auth")
				@change[0].MECheckDate = DateTime.parse time
				@change[0].MEChecker = name
				if @change[0].save
					render :text => '审核成功'
				else
					render :text => '审核失败'
				end
				# render :json => @change[0]
			else
				return nopower!
			end
		when 'pz'
			if power(T_Change_Auth, "quality_auth")
				if @change[0].MEChecker
					@change[0].QTCheckDate = DateTime.parse time
					@change[0].QTChecker = name
					if @change[0].save
						render :text => '品质审核成功'
					else
						render :text => '品质审核失败'
					end
				else
					render :text => 'ME未审核'
				end
			else
				return nopower!
			end
		end
			
	end


	def show
		if power(T_K3_Auth, "t_change_auth")
			starttime = params[:starttime]
			endtime = params[:endtime]
			conn = ActiveRecord::Base.connection()
			sql = "select
				h.FBillNo as 单据编号,
				h.FDate as 制单日期,
				(select fname from t_User where FUserID = h.FBillerID) as 制单人,
				(select fname from t_User where FUserID = h.FCheckerID) as 审核人,
				h.FCheckDateLong as 审核日期,
				h.MEchecker as ME审核人,
				h.MECheckDate as ME审核时间,
				h.QTChecker as 品质审核人,
				h.QTCheckDate as 品质审核时间,
				a.FICMOInterBN as 生产任务单号,
				b.fnumber as 产品代码, 
				b.fname as 产品名称, 
				c.fname as 生产单位, 
				a.FAuxQty as 生产数量, 
				a.FPPBomBillNo as 生产投料单号, 
				a.FPPBOMEntryID as 生产投料行号, 
				a.FChangeFlag as 变更标志, 
				a.FChangeReason as 变更原因, 
				d.fnumber as 物料代码, 
				d.fname as 物料名称, 
				a.FAuxQtyScrap as 单位用量, 
				e.fname as 单位, 
				a.FBOMInPutAuxQTY as 标准用量, 
				a.FScrap as 损耗率, 
				a.FAuxQtyLoss as 损耗数量, 
				a.FAuxQtyPick as 应该数量, 
				a.FAuxQtyMust as 计划投料数量, 
				a.FSendItemDate as 计划发料日期, 
				f.fname as 仓库, 
				a.FBatchNo as 批号, 
				g.fname as 变更人, 
				a.FChangeDate as 变更日期, 
				a.FNote1 as 备注 
				from ppbomchangeEntry a							 
				left join t_icitem b on a.FProductItemID = b.FItemID  
				left join t_MeasureUnit c on a.FUnitID = c.FMeasureUnitID 
				left join t_icitem d on a.FItemID = d.FItemID 
				left join t_MeasureUnit e on a.FItemUnitID = e.FMeasureUnitID 
				left join t_stock f on f.fitemid = a.FStockID 
				left join t_User g on g.FUserID = a.FChangerID 
				left join ppbomchange h on h.FID = a.FID where h.FDate>= "
			if starttime&&endtime
				@data = conn.select_all(sql+"'"+starttime+"' and h.FDate<='"+endtime+"'")
				render :json  => {:data => @data}
			else
				@data = conn.select_all(sql+"dateadd(week,-1,getdate())")
				render :json  => {:data => @data}
			end
		else
			return nopower!
		end
		
	end

	def header1 #投料单表头
		fbillno = params[:fbillno]
		sql = "select 
			a.FBillNo as 单据编号,
			a.FDate as 制单日期,
			(select fname from t_User where FUserID = a.FBillerID) as 制单人,
			(select fname from t_User where FUserID = a.FCheckerID) as 审核人,
			a.FCheckDateLong as 审核日期,
			a.MEchecker as ME审核人,
			a.MECheckDate as ME审核时间,
			a.QTChecker as 品质审核人,
			a.QTCheckDate as 品质审核时间,
			a.FID from ppbomchange a
			where a.fbillno = '"
		conn = ActiveRecord::Base.connection()
		@header = conn.select_all(sql+fbillno+"'")
		render :json => @header

	end

	def body1 # 投料单表体
		fbillno = params[:fbillno]
		sql = "select
			a.FICMOInterBN as 生产任务单号,
			b.fnumber as 产品代码, 
			b.fname as 产品名称, 
			c.fname as 生产单位, 
			a.FAuxQty as 生产数量, 
			a.FPPBomBillNo as 生产投料单号, 
			a.FPPBOMEntryID as 生产投料行号, 
			a.FChangeFlag as 变更标志, 
			a.FChangeReason as 变更原因, 
			d.fnumber as 物料代码, 
			d.fname as 物料名称, 
			a.FAuxQtyScrap as 单位用量, 
			e.fname as 单位, 
			a.FBOMInPutAuxQTY as 标准用量, 
			a.FScrap as 损耗率, 
			a.FAuxQtyLoss as 损耗数量, 
			a.FAuxQtyPick as 应该数量, 
			a.FAuxQtyMust as 计划投料数量, 
			a.FSendItemDate as 计划发料日期, 
			f.fname as 仓库, 
			a.FBatchNo as 批号, 
			g.fname as 变更人, 
			a.FChangeDate as 变更日期, 
			a.FNote1 as 备注
			from ppbomchangeEntry a							 
			left join t_icitem b on a.FProductItemID = b.FItemID  
			left join t_MeasureUnit c on a.FUnitID = c.FMeasureUnitID 
			left join t_icitem d on a.FItemID = d.FItemID 
			left join t_MeasureUnit e on a.FItemUnitID = e.FMeasureUnitID 
			left join t_stock f on f.fitemid = a.FStockID 
			left join t_User g on g.FUserID = a.FChangerID 
			left join ppbomchange h on h.FID = a.FID 
			where h.FBillNo = '"
		conn = ActiveRecord::Base.connection()
		@body = conn.select_all(sql+fbillno+"'")
		render :json => {:data => @body}
	end


	def review1
		fbillno = params[:fbillno]
		name = params[:name]
		type = params[:type]
		billno = params[:billno]
		today = Time.new
		time =  today.strftime("%Y-%m-%d %H:%M:%S").to_s  

		@change = Change.where("fbillno = ?", fbillno)
		case type
		when 'me'
			case billno
			when '02'
				if power(T_Change_Auth, "ic_auth")
					@change[0].MECheckDate = DateTime.parse time
					@change[0].MEChecker = name
					if @change[0].save
						render :text => '审核成功'
					else
						render :text => '审核失败'
					end
					# render :json => @change[0]
				else
					return nopower!
				end
			when '03'
				if power(T_Change_Auth, "to_auth")
					@change[0].MECheckDate = DateTime.parse time
					@change[0].MEChecker = name
					if @change[0].save
						render :text => '审核成功'
					else
						render :text => '审核失败'
					end
					# render :json => @change[0]
				else
					return nopower!
				end
			when '04'
				if power(T_Change_Auth, "device_auth")
					@change[0].MECheckDate = DateTime.parse time
					@change[0].MEChecker = name
					if @change[0].save
						render :text => '审核成功'
					else
						render :text => '审核失败'
					end
					# render :json => @change[0]
				else
					return nopower!
				end
			when '05'
				if power(T_Change_Auth, "module_auth")
					@change[0].MECheckDate = DateTime.parse time
					@change[0].MEChecker = name
					if @change[0].save
						render :text => '审核成功'
					else
						render :text => '审核失败'
					end
					# render :json => @change[0]
				else
					return nopower!
				end
			else
				render :text => '此单据不予审核'
			end
				
		when 'pz'
			if power(T_Change_Auth, "quality_auth")
				if @change[0].MEChecker
					@change[0].QTCheckDate = DateTime.parse time
					@change[0].QTChecker = name
					if @change[0].save
						render :text => '品质审核成功'
					else
						render :text => '品质审核失败'
					end
				else
					render :text => 'ME未审核'
				end
			else
				return nopower!
			end
		end
	end
end
