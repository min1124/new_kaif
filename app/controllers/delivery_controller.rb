class DeliveryController < ApplicationController
	def index
		number = params[:number]
		if power(T_K3_Auth, "t_delivery_auth")
			@a = LtePack.find_by_sql(" select b.FBillno,count(a.serial_no) as Die_Qty  from 
			 (select serial_no,coding_no from lte_packing where State = 14) a 
			 join (select coding_no as FBillNo,serial_no from lte_packing where state = 13) b on a.serial_no = b.serial_no
			 where a.coding_no = '"+number+"'
			 group by b.fbillno")
			conn = ActiveRecord::Base.connection()
			@data = conn.select_all("select distinct 
			a.FBillno,
			a.FHeadSelfB0166 ,   --客户订单号
			b.FEntrySelfB0171 ,  --任务令
			b.FMapNumber ,   --客户代码
			b.FMapName ,   --客户型号
			c.FName   --正源型号
			from icstockbill a join icstockbillentry b on a.finterid = b.finterid 
			join t_icitem c on b.fitemid = c.fitemid 
			where a.FBillno = '"+@a[0].FBillno+"'")
			@data[0]['Die_Qty'] = @a[0].Die_Qty
			@data[0]['Carton'] = number
			@b = Order.find_by task_num: @data[0]['FEntrySelfB0171']
			if @b
				@data[0]['num'] = @b.qty_request
			else
				@data[0]['num'] = ''
			end
			@data[0]['FMapNumber'] = @data[0]['FMapNumber'][1,@data[0]['FMapNumber'].length-1]
			@data[0]['FName'] = @data[0]['FName'].split('#')[0]
			@data[0]['C_ITEM'] = Asn.select(:CPN1).where("ITEM = ?",@data[0]['FMapNumber']) 
			render :json =>@data 
		else
			return nopower!
		end
	end

	def hs_2
		if power(T_K3_Auth, "t_delivery_auth")
			today = Time.new
			time = today.strftime("%Y-%m-%d")
			conn = ActiveRecord::Base.connection()
			@a = conn.select_all("select distinct 
			a.FBillno,
			a.FDate,
			a.FHeadSelfB0166 ,   --客户订单号
			b.FEntrySelfB0171 ,  --任务令
			b.FMapNumber ,   --客户代码
			b.FMapName ,   --客户型号
			c.FName   --正源型号
			from icstockbill a join icstockbillentry b on a.finterid = b.finterid 
			join t_icitem c on b.fitemid = c.fitemid 
			where a.FDate ='"+time+"'")
			render :json => {:data =>@a}
		else
			return nopower!
		end
	end

	def test
		# all = Order.count
		hw = Order.where(order_type: 'hw').count
		zx = Order.where(order_type: 'zx').count
		fh = Order.where(order_type: 'fh').count
		hs = Order.where(order_type: 'hs').count
		hash =Hash.new 
		hash['hw'] = hw
		hash['zx'] = 60
		hash['fh'] = 110
		hash['hs'] = 80
		render :json => hash
	end
end





