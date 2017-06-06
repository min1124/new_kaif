class TabboxController < ApplicationController
	def fbillno
		fbillno = params[:fbillno]
		sql = "select c.fnumber,sum(b.fQty) as fQty from  ICStockBill  a
		left join ICStockBillEntry b on a.finterid = b.finterid
		left join t_ICItem c on b.FItemID = c.FItemID
		where a.fbillno='"+fbillno+"' and a.FTranType='24' group by c.fnumber"
		conn = ActiveRecord::Base.connection
		@data = conn.select_all(sql)
		render :json => @data
	end

	def hh
		hh = params[:hh]
		sql = "select a.BoxNo,a.BarCode,a.BatchNum,a.FKFDate,b.fnumber from TabBox a
		left join t_ICItem b on a.FItemID = b.FItemID where a.BoxNo = '"+hh+"'"
		conn = ActiveRecord::Base.connection
		@tabbox = conn.select_all(sql)
		render :json => @tabbox
	end

	def save
		bh = params[:bh]
		boxno = params[:boxno]
		barcode = params[:barcode]
		fnumber = params[:fnumber]
		batchnum = params[:batchnum]
		fkdate = params[:fkdate]
		today = Time.new
		time = today.strftime("%Y-%m-%d %H:%M:%S")
		b = Array.new
		for i in 0..boxno.length-1
			a = Tbox.new
			a.billno = bh
			a.boxno = boxno[i]
			a.barcode = barcode[i]
			a.fnumber = fnumber[i]
			a.num = batchnum[i]
			a.fkdate = Date.parse fkdate[i]
			a.savedate = DateTime.parse time
			a.save!
			b.push(a)
		end
		render :txet => "保存成功"
	end

	def index
		@tbox = Tbox.all
		render :json =>{:data =>@tbox}
	end
end
