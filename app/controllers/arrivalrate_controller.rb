class ArrivalrateController < ApplicationController
	def upload
		type = params[:type]
		tmp = params[:file]
		today = Time.new
		time = today.strftime("%Y-%m-%d %H:%M:%S")
		require 'fileutils' #ruby老版本可尝试改为 require 'ftools'
		require "spreadsheet" #打开excel文件
		file = File.join("public", tmp.original_filename)
		FileUtils.cp tmp.path, file
		Spreadsheet.client_encoding = 'UTF-8'
		file = Spreadsheet.open("public/"+tmp.original_filename)
		sheet = file.worksheet(0)
		row1 = sheet.row(0)
		i = 0
		a = Array.new
		b = Array.new
		ArrivalRate.transaction do
			sheet.each  do |row|
				if row[0]==nil
				else
					if row[0]=="物料长代码"
						@arinfo = Ar_Info.new
						@arinfo.create_time = DateTime.parse time.to_s
						@arinfo.date1 = row[5]
						@arinfo.date2 = row[6]
						@arinfo.date3 = row[7]
						@arinfo.date4 = row[8]
						@arinfo.date5 = row[9]
						@arinfo.date6 = row[10]
						@arinfo.date7 = row[11]
						@arinfo.date8 = row[12]
						@arinfo.save!
						a.push(@arinfo)
					else
						i = i+1
					end
				end
			end
			for j in 0..i/2-1
				ar = ArrivalRate.new
				ar.info_id = @arinfo.id
				ar.fnumber = sheet.row(1+j*2)[0]
				ar.fname = sheet.row(1+j*2)[1]
				ar.PMC = sheet.row(1+j*2)[2]
				ar.Buyer = sheet.row(1+j*2)[3]
				ar.week1_1 = sheet.row(1+j*2)[6].to_i#需求，，，前一个数字代表第几列，后面的1代表需求，2代表采购回复
				ar.week1_2 = sheet.row(2+j*2)[6].to_i#采购回复
				ar.week2_1 = sheet.row(1+j*2)[7].to_i
				ar.week2_2 = sheet.row(2+j*2)[7].to_i
				ar.week3_1 = sheet.row(1+j*2)[8].to_i
				ar.week3_2 = sheet.row(2+j*2)[8].to_i
				ar.week4_1 = sheet.row(1+j*2)[9].to_i
				ar.week4_2 = sheet.row(2+j*2)[9].to_i
				ar.week5_1 = sheet.row(1+j*2)[10].to_i
				ar.week5_2 = sheet.row(2+j*2)[10].to_i
				ar.week6_1 = sheet.row(1+j*2)[11].to_i
				ar.week6_2 = sheet.row(2+j*2)[11].to_i
				ar.week7_1 = sheet.row(1+j*2)[12].to_i
				ar.week7_2 = sheet.row(2+j*2)[12].to_i
				ar.save!
				b.push(ar)
			end
		end
		render :json => {:date1 => a, :date2 => b}
		# render :text => sheet.row(1)[0]
	end

	def index
		id = params[:id]
		if id
			@ar = Ar_Info.find(id)
			render :json => @ar
		else
			@ar = Ar_Info.order(create_time: :desc).first
			render :json => @ar
		end
	end

	def info
		rs = params[:rs]
		id = rs[:id]
		date1 = rs[:date1]
		date2 = rs[:date2]
		date3 = rs[:date3]
		date4 = rs[:date4]
		date5 = rs[:date5]
		date6 = rs[:date6]
		date7 = rs[:date7]
		date8 = rs[:date8]
		date2_1 = (Date.parse(date2)+1).to_s
		date3_1 = (Date.parse(date3)+1).to_s
		date4_1 = (Date.parse(date4)+1).to_s
		date5_1 = (Date.parse(date5)+1).to_s
		date6_1 = (Date.parse(date6)+1).to_s
		date7_1 = (Date.parse(date7)+1).to_s
		@ar_rate = ArrivalRate.where(info_id: rs[:id])
		b = Array.new
		# data = Array.new
		i = 0
		@data = ArrivalRate.find_by_sql("exec GIMS_AR_Qty '"+date1+"','"+date2+"','"+
			date2_1+"','"+date3+"','"+date3_1+"','"+date4+"','"+date4_1+"','"+date5+"','"+
			date5_1+"','"+date6+"','"+date6_1+"','"+date7+"','"+date7_1+"','"+date8+"',"+id)#.take(10)		
		render :json => @data#{:data => @data}
	end

	def getid
		if power(T_K3_Auth, "t_return_auth")
			@rp = Ar_Info.where("create_time >= :starttime and create_time <= :endtime",{starttime: params[:starttime],endtime: params[:endtime]})
			render :json =>{:data =>@rp}
		else
			return nopower!
		end
	end

	def delete
		id = params[:id]
		ArrivalRate.transaction do
			ar_info = Ar_Info.find(id)
			ar_info.destroy
			ar = ArrivalRate.where("info_id = ?",id)
			ar.each do |f|
				f.destroy
			end
		end
		render :text => "删除成功"
	end
end











