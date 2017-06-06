class OrderController < ApplicationController
	before_action :authentication, only:[:index,:edit,:fnumber,:ghdw,:ywy ]

	def index
		if power(T_K3_Auth, "t_order_auth")
			starttime=params[:starttime]
	    	endtime=params[:endtime]
			type = params[:type]
			if type == 'zx'||type == 'zxhub'
				@order = Order.find_by_sql("select * from V_ZX where order_type = '"+type+"'")
				render :json => {:data =>@order}
			else
				if type == 'other'
					@order = Order.find_by_sql("select * from V_ZX where order_type ='other'")
					render :json => {:data =>@order}
				else
					if endtime&&starttime
						if endtime==""||starttime==""
							@order = Order.find_by_sql("select * from V_Order where order_type ='"+type+"'")#.paginate(page:params[:page],per_page:10)
							render :json => {:data =>@order}
						else
							@order = Order.find_by_sql("select * from V_Order where order_type ='"+type+"' and date>'"+starttime+"' and date<'"+endtime+"'")#.paginate(page:params[:page],per_page:10)
							render :json => {:data =>@order}
						end
					else
						@order = Order.find_by_sql("select * from V_Order where order_type ='"+type+"'")#.paginate(page:params[:page],per_page:10)
						render :json => {:data =>@order}
					end
				end
			end
		else
			return nopower!
		end
	end

	def upload
		type = params[:type]
		tmp = params[:file]
		today = Time.new
		time = today.strftime("%Y-%m-%d %H:%M:%S")
		require 'fileutils' #ruby老版本可尝试改为 require 'ftools'
		require "spreadsheet" #打开excel文件
		# file = File.join("public", tmp.original_filename)
		# FileUtils.cp tmp.path, file
		# Spreadsheet.client_encoding = 'UTF-8'
		if File.exist?("public/"+tmp.original_filename)
			render :text => '文件已存在,请勿重复上传'
		else
			file = File.join("public", tmp.original_filename)
			FileUtils.cp tmp.path, file
			Spreadsheet.client_encoding = 'UTF-8'
			file = Spreadsheet.open("public/"+tmp.original_filename)
			sheet = file.worksheet(0)
			row1 = sheet.row(0)
			case type
			when "hw"	
				if row1[0] == "po_change_type"
					Order.transaction do
						sheet.each  do |row|
							if row[0]=="po_change_type"
								
							else
								order = Order.new
								order.business_mode = row[row1.index("business_mode")]#订类型
								order.po_number = row[row1.index("po_number")]#客户订单编号
								order.po_line_num = row[row1.index("po_line_num")]#客户订单行号
								order.supplier_item = row[row1.index("supplier_item")]#对应型号
								order.customer_item = row[row1.index("customer_item")]#对应代码
								order.vendor_code = row[row1.index("vendor_code")]#可选项 供应商代码
								order.vendor_name = row[row1.index("vendor_name")]#可选项 供应商名称
								order.qty_request = row[row1.index("qty_request")]#需求数量
								order.request_date = row[row1.index("request_date")]# 需求日期
								order.promise_date = row[row1.index("promise_date")]#可选项 承诺日期
								order.last_promise_date = row[row1.index("last_promise_date")]#可选项 最后承诺日期
								order.task_num = row[row1.index("task_num")]# 任务令
								order.unit_price = row[row1.index("unit_price")]# 不含税价格
								order.creation_date = row[row1.index("creation_date")]#下单日期
								order.order_type = 'hw'
								order.date = time
								order.save
							end
						end
					end
					File.delete("public/"+tmp.original_filename)
					render :text  => '上传成功'
				else
					File.delete("public/"+tmp.original_filename)
					render :text  => '文件类型不匹配,请选择对应的客户'
				end	
			when "zx"
				if row1[0] == "需方代表"
					a = Array.new
					Order.transaction do
						sheet.each  do |row|
							if row[0]=="需方代表"
								
							else
								order_e = Order.where("po_number = ? AND customer_item = ? ",row[row1.index("合同编号")],row[row1.index("物料代码")])
								if order_e[0]
									order_e[0].qty_request = order_e[0].qty_request + row[row1.index("订购数量")]
									if row[row1.index("交货日期")].to_s> order_e[0].request_date.to_s
										order_e[0].request_date=row[row1.index("交货日期")]
									else
									end
									order_e[0].save!
								else
									order = Order.new
									order.po_number = row[row1.index("合同编号")]#客户订单编号
									order.po_line_num = '1'#客户订单行号
									order.supplier_item = row[row1.index("规格型号")]#对应型号
									order.customer_item = row[row1.index("物料代码")]#对应代码
									order.qty_request = row[row1.index("订购数量")]#需求数量
									order.request_date = row[row1.index("交货日期")]# 需求日期
									# order.task_num = row[row1.index("task_num")]# 任务令
									order.unit_price = row[row1.index("价格")]# 不含税价格
									order.creation_date = row[row1.index("合同发送日期")]#下单日期
									order.order_type = 'zx'
									order.date = time
									#order.business_mode = '普通销售'
									zxhub =  Zxhub.where("model = ? and fnumber = ? ",order.supplier_item,order.customer_item)
									if zxhub[0]
										case zxhub[0].address
										when 'VMI'
											order.business_mode = 'VMI补货'
										when "BHUB"
											order.business_mode = 'HUB补货'
										when "B"
											order.business_mode = '普通销售'
										end
										
									else
									end
									order.save!
								end
							end
						end
					end
					render :text => '上传成功'
				else
					File.delete("public/"+tmp.original_filename)
					render :text => sheet.row(1)[0]#'文件类型不匹配,请选择对应的客户'
				end	
			when "fh"
				if row1[0] == "供应商"
					Order.transaction do
						sheet.each  do |row|
							if row[0]=="供应商"
								
							else
								order = Order.new
								#order.business_mode = "Normal"#订类型
								fhVmi = row[row1.index("项目类别")]#项目类别
								if fhVmi
									case fhVmi
									when '标准'
										order.business_mode = '普通销售'
									when "寄售"
										order.business_mode = 'VMI补货'
									end
								else
								end

								order.po_number = row[row1.index("采购凭证")].to_s.split('.')[0]#客户订单编号
								order.po_line_num = row[row1.index("项目")].to_s.split('.')[0]#客户订单行号
								order.supplier_item = row[row1.index("短文本")].split('/')[0]#对应型号
								order.customer_item = row[row1.index("物料")]#对应代码
								order.qty_request = row[row1.index("采购订单数量")]#需求数量
								order.request_date = row[row1.index("交货日期")]# 需求日期
								order.task_num = ''# 任务令
								order.unit_price = row[row1.index("净价")]# 不含税价格
								order.creation_date = row[row1.index("凭证日期")]#下单日期
								order.order_type = 'fh'
								order.date = time
								order.save
							end
						end
					end
					File.delete("public/"+tmp.original_filename)
					render :text => '上传成功'
				else
					File.delete("public/"+tmp.original_filename)
					render :text => '文件类型不匹配,请选择对应的客户'
				end	
			when "njy"
				# a = Array.new
				if row1[0] == "Purchase Order"
					Order.transaction do
						sheet.each  do |row|
							if row[0]=="Purchase Order"
								
							else
								order = Order.new
								order.business_mode = "Normal"#订类型
								order.po_number = row[row1.index("Purchase Order")][2,row[row1.index("Purchase Order")].length-1]#客户订单编号
								order.po_line_num = row[row1.index("Order Line Id")].to_i#客户订单行号
								order.supplier_item = row[row1.index("Material Code Description")]#对应型号
								order.customer_item = row[row1.index("Material Code")]#对应代码
								order.qty_request = row[row1.index("Request Qty")]#需求数量
								request_date =row[row1.index("Request Date")].split("/")# 需求日期
								order.request_date = request_date[2]+"-"+request_date[0]+"-"+request_date[1]
								order.task_num = ''# 任务令
								order.unit_price = row[row1.index("Unit Price")]# 不含税价格
								creation_date =row[row1.index("Purchase Order Creation Date")].split("/")#下单日期
								order.creation_date = creation_date[2]+"-"+creation_date[0]+"-"+creation_date[1]
								order.order_type = 'njy'
								order.date = time
								order.save!
							end
						end
					end
					File.delete("public/"+tmp.original_filename)
					render :text  => "上传成功"
				else
					File.delete("public/"+tmp.original_filename)
					render :text  => '文件类型不匹配,请选择对应的客户'
				end	
			when "hs"
				if row1[0] == "null"
					re_date =  DateTime.parse sheet.row(1)[0]
					po_number = tmp.original_filename.split('.')[0]
					row_n = sheet.row(21)
					Order.transaction do
						sheet.each  do |row|
							if row[0]=="WO_DD"
								order = Order.new
								order.business_mode = "Normal"#订类型
								order.po_number = po_number#客户订单编号
								order.po_line_num = row[row_n.index("Shipment")].to_i#客户订单行号
								order.supplier_item = row[row_n.index("MPN")]#对应型号
								order.customer_item = row[row_n.index("Item")]#对应代码
								order.qty_request = row[row_n.index("PO Qty")]#需求数量
								order.request_date = row[row_n.index("Needby Date")]# 需求日期
								order.task_num = ''# 任务令
								order.unit_price = row[row_n.index("Price")]# 不含税价格
								order.creation_date = re_date#下单日期
								order.order_type = 'hs'
								order.date = time
								order.save
							else
								
							end
						end
					end
					File.delete("public/"+tmp.original_filename)
					render :text => "上传成功"
				else
					puts row1[0]
					File.delete("public/"+tmp.original_filename)
					render :text  => '文件类型不匹配,请选择对应的客户'
				end
			when "zxhub"
				a = Array.new
				if row1[0] == "送货单号"
					Order.transaction do
						sheet.each  do |row|
							if row[3]!=nil&&row[3]!='材料代码'
								po_number = 'J-'+row[row1.index("合同号码")]#订单编号
								supplier_item = row[row1.index("规格型号")]#型号
								customer_item = "0"+row[row1.index("材料代码")].to_i.to_s#项目编码
								unit_price = row[row1.index("合同单价")]#单价
								order_e = Order.where("supplier_item = ? and customer_item = ? and unit_price = ? and order_type = ?",supplier_item,customer_item,unit_price, 'zxhub')
								
								if order_e[0]&&row[row1.index("入库日期")].to_s[0,7]==order_e[0].request_date.to_s[0,7]
									order_e[0].qty_request = order_e[0].qty_request + row[row1.index("实收数量")]
									# if row[row1.index("入库日期")].to_s == order_e[0].request_date.to_s
										
									# else
									# end
									# puts order_e[0].request_date.to_s[0,6]
									order_e[0].save
									
								else
									order = Order.new
									zxhub =  Zxhub.where("model = ? and fnumber = ? ",supplier_item,customer_item)
									order.po_number = po_number
									order.po_line_num = "1"
									order.supplier_item = supplier_item
									order.customer_item = customer_item
									order.qty_request = row[row1.index("实收数量")]
									order.unit_price = unit_price
									order.request_date = row[row1.index("入库日期")]
									order.order_type = 'zxhub'
									order.date = time
									if zxhub[0]
										case zxhub[0].address
										when 'VMI'
											order.business_mode = 'VMI结算'
											# a.push(order)
											order.save
										when "BHUB"
											order.business_mode = 'HUB结算'
											# a.push(order)
											order.save
										when "B"
											
										end
									else
									end
								end
							else
								
							end
						end
					end
					File.delete("public/"+tmp.original_filename)
					render :text => '上传成功'
				else
					File.delete("public/"+tmp.original_filename)
					render :text  => '文件类型不匹配,请选择对应的客户'
				end
			end
		end
	end

	def edit
		if power(T_K3_Auth, "t_order_auth")
			id = params[:id]
			type = params[:type]
			fnumber = params[:fnumber]
			conn = ActiveRecord::Base.connection()
			sql1 = "select a.fnumber,a.fname,a.fmodel,u.fname as funit,a.FUnitID,c.fname as fenlei,c.finterid as fenlei_id
					from t_ICItem a
					left join t_MeasureUnit u on a.FUnitID=u.FMeasureUnitID 
					left join t_SubMessage c on a.ftypeid = c.finterid 
					where a.fnumber = '"
			sql2 = "select fnumber,fname from t_Organization where fname like '"
			@icitem = conn.select_all(sql1+fnumber+"'")
			@order = Order.find(id)
			case type
			when "hw"
				sql2 = sql2 +"华为%' or fname like'海思%'"
			when "fh"
				sql2 = sql2 +"烽火%'"
			when "zx"
				sql2 = sql2 +"中兴%'"
			when "njy"
				sql2 = sql2 +"%诺基亚%'"
			when "hs"
				sql2 = sql2 +"华三%'"
			end
			case @order.business_mode
			when "VCI-PO"
				fbillno = fbillno("t_BOS270000001",9,"HGOAV","FText5")
			when "VCI-VRN"
				fbillno = fbillno("t_BOS270000001",9,"HGOAV","FText5")
			when "VCI-CA"
				fbillno = fbillno("SEOrder",8,"HGOA","FHeadSelfS0155")
			when "Normal"
				fbillno = fbillno('SEOrder',8,"HGOA","FHeadSelfS0155")
			when "DUN"
				fbillno = fbillno('SEOrder',8,"HGOA","FHeadSelfS0155")
			end	

			@ghhw = conn.select_all(sql2)
			@a =conn.select_all(" select FItemID,FName from t_Department")#部门
			@b = conn.select_all(" select FCurrencyID,FName from t_currency")#币别
			# @c = conn.select_all(" select FItemID,FNumber,FName from t_emp")#业务员
			@c = conn.select_all(" select FInterID,FName from t_SubMessage where ftypeid = 101")#销售方式
			render :json =>	{:data1 =>@icitem,:data2 =>@order,:data3 => @ghhw,:data4 =>fbillno,:data5 =>@a,:data6 =>@b,:data7 =>@c}
		else
			return nopower!
		end
	end

	def fnumber
		if power(T_K3_Auth, "t_order_auth")
			type = params[:type]
			order_type = params[:order_type]
			id = params[:id]
			customer_number = params[:customer_number]
			order = Order.find(id)
			if type =='zxhub'
				address = 'V_Zxcode'
				ctype = '中兴'
			else
				address = 'V_Hwcode'
				ctype = '华为'
			end
			if order.flag==1
				render :text => '该订单已关闭'
			else
				if(order_type=="VMI结算"||order_type=="HUB结算")
					sql = "select distinct(a.FNumber) as fnumber from V_Inventory a LEFT join "+address+" b on a.FNumber = b.物料代码 where a.CType = '"+ctype+"' and b.客户代码 = '"+customer_number+"'"
					@fnumber = Cust_Fnumber.find_by_sql(sql)
					# @fnumber = ActiveRecord::Base.connection().select_all("select distinct b.fnumber from ICInventory j join t_Stock s on j.FStockID= s.FItemID join t_icitem b on j.fitemid = b.fitemid where s.fnumber = '"+address+"' and j.FQty > 0")
				else
					@fnumber = Cust_Fnumber.where("customer_number = ? and shipping_or_not = ?",customer_number,'Y')
				end
				
				render :json => {:data =>@fnumber}
			end
		else
			return nopower!
		end
	end

	def ghdw
		if power(T_K3_Auth, "t_order_auth")
			ghdw = params[:ghdw]
			conn = ActiveRecord::Base.connection()
			sql = "select a.F_102,a.F_103,b.FName from t_Organization a 
					left join t_item b on a.F_103 = b.fitemid
					where a.fnumber ='"
			@a = conn.select_all(sql+ghdw+"'")
			render :json => @a
		else
			return nopower!
		end
	end

	def create_1
		conn = ActiveRecord::Base.connection()
		fname = params[:ddlx]
		ddlx = conn.select_value("select FItemID from t_item where FItemClassID = 3009 and FName = '"+fname+"'")#订单类型
		bh = params[:bh]#编号
		rq = Date.parse params[:rq] #日期
		jdrq = Date.parse params[:jdrq] #接单日期
		zd = conn.select_value("select FUserID from t_user where fname = '"+params[:zd]+"'") #制单人
		bm = params[:bm] #部门
		ddbh = params[:ddbh] #客户订单编号
		ghdw = conn.select_value("select FItemID from t_organization where fnumber ='"+params[:ghdw]+"'")#购货单位

		if fname=="普通销售"||fname=="VMI结算"||fname=="现款销售"||fname=='HUB结算'||fname=='换货订单'

			@seorder = Seorder.new
			# @seorderentry = Seorderentry.new
			@seorder.FHeadSelfS0157 = params[:lxkh] #零星客户全称
			@seorder.FBillNo = bh
			@seorder.FAreaPS = 20302
			@seorder.FPlanCategory = 1
			@seorder.FTranType = 81
			@seorder.FBrNo = 0
			@seorder.FCustID = ghdw
			finterid = conn.select_value("select Fmaxnum from icmaxnum where FTableName = 'SEOrder'")+1
			@seorder.FHeadSelfS0152 = ddlx
			@seorder.FHeadSelfS0155 = ddbh
			@seorder.FHeadSelfS0153 = jdrq
			# khdm = params[:khdm]
			@seorder.FHeadSelfS0154 = params[:xspq]
			@seorder.FDate = rq
			# @seorder.fprice = params[:dj_1]
			# @seorder.fauxprice = params[:dj_1]

			@seorder.FBillerID = zd
			@seorder.FHeadSelfS0157=""
			@seorder.FCurrencyID = params[:bb]
			@seorder.FSaleStyle = params[:xsfs]
			@seorder.FDeptID = bm
			@seorder.FEmpID = params[:ywy]
			@seorder.FExchangeRate = conn.select_value("select FExchangeRate from t_currency where FCurrencyID ="+params[:bb]+"")

			ActiveRecord::Base.transaction do
				while conn.select_value("select finterid from seorder where finterid ="+finterid.to_s)
					puts finterid
					finterid = finterid+1
				end
				@seorder.FInterID = finterid
				
				@seorder.save!
				conn.update("update icmaxnum set Fmaxnum = "+finterid.to_s+" where FTableName = 'SEOrder'")

				# fentry = "1"
				cpmc_1 = params[:cpmc_1]
				ddhh_1 = params[:ddhh_1]
				dydm_1 = params[:dydm_1]
				rwl_1 = params[:rwl_1]
				puts rwl_1
				cpdm_1 = params[:cpdm_1]
				# cpdm_1 = conn.select_value("select fitemid from t_icitem where fnumber ='"+params[:cpdm_1]+"'").to_s
				dj = params[:dj_1]
				hsdj = params[:hsdj_1]

				dw_1 = params[:dw_1]
				# dw_1 = conn.select_value("select FItemid from t_MeasureUnit where FName ='"+params[:dw_1]+"'").to_s
				
				sl_1 = params[:sl_1]
				
				# je = (dj.to_f*sl_1.to_f).to_s 
				# sjhj = (hsdj.to_f*sl_1.to_f).to_s #税价合计
				sl_2 = "17.00"
				jhrq_1 = params[:jhrq_1]
				cnjhrq_1 = params[:cnjhrq_1]
				wlfl_1 = params[:wlfl_1]

				for i in 0..cpmc_1.length-1	
					cpdm_1[i] = conn.select_value("select fitemid from t_icitem where fnumber ='"+cpdm_1[i]+"'").to_s
					dw_1[i] = conn.select_value("select FItemid from t_MeasureUnit where FName ='"+dw_1[i]+"'").to_s
					dyxh_1 = conn.select_value("select FMapName from ICItemMapping where FMapNumber = '"+dydm_1[i]+"' and FCompanyID ="+ghdw.to_s)
					je = (dj[i].to_f*sl_1[i].to_f).to_s #
					sjhj = (hsdj[i].to_f*sl_1[i].to_f).to_s #税价合计
					shuie = (dj[i].to_f*sl_1[i].to_f*0.17).to_s #税额
					sql2 = "insert into seorderentry (FTaxAmt,FAuxPriceDiscount,FPriceDiscount,FAllAmount,FALLStdAmount,FTaxPrice,FAuxTaxPrice,FAmount,fprice,fauxprice,finterid,FBrNo,FEntryID,FEntrySelfS0164,FMapNumber,FEntrySelfS0168,FItemID,FUnitID,FQty,FAuxQty,FCESS,FDate,FEntrySelfS0166,FEntrySelfS0167,FAdviceConsignDate,FMapName) values ("+
						shuie+","+hsdj[i]+","+hsdj[i]+","+sjhj+","+sjhj+","+hsdj[i]+","+hsdj[i]+","+je +","+dj[i]+","+dj[i]+","+finterid.to_s+","+"0"+","+(i+1).to_s+",'"+ddhh_1[i]+"','"+dydm_1[i]+"','"+rwl_1[i].to_s+"',"+cpdm_1[i]+","+dw_1[i]+","+sl_1[i]+","+sl_1[i]+","+sl_2+",'"+jhrq_1[i]+"','"+cnjhrq_1[i]+"','"+wlfl_1[i].to_s+"','"+jhrq_1[i]+"','"+dyxh_1.to_s+"')"
					puts sql2
					conn.insert(sql2)
				end
				
			end
			render :text => '普通订单'
		else
		end
		if fname=='VMI补货'||fname=='HUB补货'
			@vmi = Vmi.new  #vmi 主表
			# @vmientry = Vmientry.new #vmi 从表
			@vmi.FBillNo = bh
			@vmi.FDate = rq
			@vmi.FDate1 = jdrq 
			@vmi.FTime = rq
			#@vmi.FTime #制单日期 
			@vmi.FBiller = zd
			@vmi.FBase1 = bm
			#@vmi.FNote  #摘要
			@vmi.FText5 = ddbh
			@vmi.FBase5 = ddlx
			@vmi.FBase = ghdw
			@vmi.FClassTypeID = 270000001

			ActiveRecord::Base.transaction do
				finterid = conn.select_value("select Fmaxnum from icmaxnum where FTableName = 't_BOS270000001'")+1
				while conn.select_value("select FID from t_BOS270000001 where FID ="+finterid.to_s)
					puts finterid
					finterid = finterid+1
				end
				@vmi.FID = finterid
				
				@vmi.save!
				conn.update("update icmaxnum set Fmaxnum = "+finterid.to_s+" where FTableName = 't_BOS270000001'")
				dydm_1 = params[:dydm_1]
				sl_1 = params[:sl_1]
				ddhh_1 = params[:ddhh_1]
				dw_1 = params[:dw_1]
				cpdm_1 = params[:cpdm_1]
				jhrq_1 = params[:jhrq_1]
				cnjhrq_1 = params[:cnjhrq_1]
				for i in 0..cpdm_1.length-1	
					@vmientry = Vmientry.new #vmi 从表
					@vmientry.FID = finterid
					@vmientry.FText = dydm_1[i]
					@vmientry.FIndex = i+1 #行号
					@vmientry.FDecimal = sl_1[i]
					@vmientry.FDecimal7 = sl_1[i]
					@vmientry.FText3 = ddhh_1[i]
					#@vmientry.FText4 #评审订单号
					@vmientry.FDate3 =  Date.parse jhrq_1[i]
					@vmientry.FDate4 = Date.parse cnjhrq_1[i]
					#@vmientry.FNOTE1 #备注
					@vmientry.FBase4 = dw_1[i]
					@vmientry.FBase3 = conn.select_value("select FItemID from t_item where FNumber ='"+cpdm_1[i]+"'")
					@vmientry.save!
				end
			end
			render :text => 'VMI订单'
		else
		end
		
	end

	
	def ywy 
		if power(T_K3_Auth, "t_order_auth")
			conn = ActiveRecord::Base.connection()
			@a =conn.select_all(" select FItemID,FNumber,FName from t_emp")
			render :json =>@a
		else
			return nopower!
		end
	end

	def edit_1
		id = params[:id]#.split(' ')
		type = params[:type]
		fnumber = params[:fnumber]#.split(' ')
		conn = ActiveRecord::Base.connection()
		sql1 = "select a.fnumber,a.fname,u.fname as funit,a.FUnitID,c.fname as fenlei,c.finterid as fenlei_id
					from t_ICItem a
					left join t_MeasureUnit u on a.FUnitID=u.FMeasureUnitID 
					left join t_SubMessage c on a.ftypeid = c.finterid 
					where a.fnumber = '"
		sql2 = "select fnumber,fname from t_Organization where fname like '"
		sql3 = "select b.fnumber,a.fprice from ICPrcPlyEntry a join t_icitem b on a.fitemid = b.fitemid 
		where FChecked = 1 and (FBegDate <= convert(varchar(10),getdate(),120) and FEndDate >= convert(varchar(10),getdate(),120)) and b.fnumber = '"
		
		arr3 = Array.new() 
		arr1 = Array.new() 
		for i in 0..fnumber.length-1
			arr1[i] = conn.select_all(sql1+fnumber[i]+"'")
			arr3[i] = conn.select_all(sql3+fnumber[i]+"'")
		end
		arr2 = Array.new() 
		for i in 0..id.length-1
			arr2[i] = Order.find(id[i])
		end
		puts arr2[0].business_mode
		case type
		when "hw"
			sql2 = sql2 +"华为%' or fname like'海思%'"
		when "fh"
			sql2 = sql2 +"烽火%'"
		when "zx","zxhub"
			sql2 = sql2 +"中兴%'"
		when "njy"
			sql2 = sql2 +"%NOKIA%'"
		when "hs"
			sql2 = sql2 +"%华三%'"
		when "other"
			sql2 = "select fnumber,fname from t_Organization "
		end
		case params[:ghdw]
		when "VMI补货","HUB补货"
			fbillno = fbillno_1("t_BOS270000001",9,"HGOAV","FText5")
		when "VMI结算","普通销售","现款销售","换货订单","HUB结算"
			fbillno = fbillno_1('SEOrder',8,"HGOA","FHeadSelfS0155")
		end	

		@ghhw = conn.select_all(sql2)
		@a =conn.select_all(" select FItemID,FName from t_Department")#部门
		@b = conn.select_all(" select FCurrencyID,FName from t_currency")#币别
		# @c = conn.select_all(" select FItemID,FNumber,FName from t_emp")#业务员
		@c = conn.select_all(" select FInterID,FName from t_SubMessage where ftypeid = 101")#销售方式
		render :json => {:data1 =>arr1,:data2 =>arr2,:data3 => @ghhw,:data4 =>fbillno,:data5 =>@a,:data6 =>@b,:data7 =>@c, :data8 =>arr3}
	end

	def fbillno_1(table,num,line,po_number)
		conn = ActiveRecord::Base.connection()
		time = Time.new.strftime("%Y%m")
		date = time[2,time.length-1]
		fbillno = conn.select_value("select  top 1 max(fbillno) as fbillno from " +table+ " where "+po_number+" ='"+params[:po_number]+"' group by len(fbillno) order by len(fbillno) desc" )
	    puts "-------------------"
		puts fbillno
		puts po_number
		puts "-------------------"
		num_1 = (num+4).to_s
		if fbillno&&params[:po_number]!=''
			if fbillno.include?'-'
				# fbillno[fbillno.length-1] = (fbillno[fbillno.length-1].to_i+1).to_s
				fbillno = fbillno.split('-')[0]+'-'+(fbillno.split('-')[1].to_i+1).to_s
			else
				fbillno = fbillno + '-1'
			end
			puts "带杠-------------------"
			puts fbillno
			puts "带杠-------------------"
		else
			fbillno = conn.select_value("select max(fbillno) from " +table+ " where len(fbillno) = "+num_1+" and fbillno like '%"+line+date+"%'")
			puts fbillno
			if fbillno
				a = fbillno[0,num]
				b = (fbillno[num,4].to_i+1).to_s
				b = b.rjust(4, '0')
 				fbillno = a + b 
			else
				fbillno = line+date+'0001'
			end
			puts "不带杠-------------------"
			puts fbillno
			puts "不带杠-------------------"
		end
		return fbillno
	end
	def fbillno(table,num,line,po_number)
		conn = ActiveRecord::Base.connection()
		time = Time.new.strftime("%Y%m")
		date = time[2,time.length-1]
		fbillno = conn.select_value("select  top 1 max(fbillno) as fbillno from " +table+ " where "+po_number+" ='"+@order.po_number+"' group by len(fbillno) order by len(fbillno) desc" )
		puts fbillno
		if fbillno
			if fbillno.include?'-'
				# fbillno[fbillno.length-1] = (fbillno[fbillno.length-1].to_i+1).to_s
				fbillno = fbillno.split('-')[0]+'-'+(fbillno.split('-')[1].to_i+1).to_s
			else
				fbillno = fbillno + '-1'
			end
			puts fbillno
		else
			fbillno = conn.select_value("select max(fbillno) from " +table+ " where len(fbillno) == 13 and fbillno like '%"+line+date+"%'")
			puts fbillno
			if fbillno
				a = fbillno[0,num]
				b = (fbillno[num,4].to_i+1).to_s
				b = b.rjust(4, '0')
 				fbillno = a + b 
			else
				fbillno = line+date+'0001'
			end
			puts fbillno
		end
		return fbillno
	end

	def orther
		conn = ActiveRecord::Base.connection()
		sql2 = "select fnumber,fname from t_Organization"
		@ghhw = conn.select_all(sql2)
		render :json => @ghhw
	end

	def ghdw_all #获取所有购货单位
		conn = ActiveRecord::Base.connection()
		sql =  "select fnumber,fname from t_Organization where fnumber like '%A.%'"
		@ghdw_all =  conn.select_all(sql)
		render :json => @ghdw_all
	end

	def new
		today = Time.new
		time = today.strftime("%Y-%m-%d %H:%M:%S")
		date = today.strftime("%Y%m")[2,time.length-1]
		customer_name = params[:name]
		po_number = params[:po_number]
		business_mode = params[:business_mode]
		ghdw_name = params[:ghdw_name].split(' ')[1]
		ghdw_code = params[:ghdw_code]
		unit_price = params[:price]#单价
		creation_date = params[:creation_date]#下单日期

		po_line_num = params[:po_line_num]#行号
		customer_item = params[:customer_item]#项目编码
		supplier_item = params[:supplier_item]#型号
		vendor_name =  params[:vendor_name]#正源型号
		qty_request = params[:qty_request]#需求数量
		request_date = params[:request_date]#需求日期

		if po_number == ''#生产po_number
			po_number = Order.find_by_sql("select max(po_number) from t_order where po_number like '%HC"+date+"%'")
			if po_number[0]['']==nil
				po_number = 'HC'+date+'001'
			else
				po_number = 'HC'+date+(po_number[0][''][6,9].to_i + 1).to_s.rjust(3, '0')
			end
		else
		end

		Order.transaction do
			for i in 0..po_line_num.length-1
				order = Order.new
				order.order_type = 'other'
				order.customer_name = customer_name
				order.po_number = po_number
				order.business_mode = business_mode
				order.ghdw_name = ghdw_name
				order.ghdw_code = ghdw_code
				order.creation_date = creation_date
				order.po_line_num = po_line_num[i]
				order.unit_price = unit_price[i]
				order.customer_item = customer_item[i]
				order.supplier_item = supplier_item[i]
				order.vendor_name = vendor_name[i]
				order.qty_request = qty_request[i]
				order.request_date = request_date[i]
				order.date = time
				order.save
			end
		end
		render :text => '保存成功'
	end

	def close
		id = params[:id]
		order = Order.find(id)
		if order.flag == 1
			render :text => '请勿重复关闭'
		else
			order.flag = 1
			if order.save!
				render :text => '关闭成功'
			else
				render :text => order.flag
			end
		end
	end

	def open
		id = params[:id]
		order = Order.find(id)
		if order.flag == 1
			order.flag = nil
			if order.save!
				render :text => '反关闭成功'
			else
				render :text => order.flag
			end
		else
			render :text => '该订单未关闭'
		end
	end

end





