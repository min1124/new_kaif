class ReturnController < ApplicationController
	before_action :authentication, only: [:index, :info,:time]
	def upload
		tmp = params[:file]
		require 'fileutils' #ruby老版本可尝试改为 require 'ftools'
		require "spreadsheet" #打开excel文件
		file = File.join("public", tmp.original_filename)
		FileUtils.cp tmp.path, file
		Spreadsheet.client_encoding = 'UTF-8'
		# if tmp.original_filename.include?".xlsx"
		# 	file = Spreadsheet.open("public/"+tmp.original_filename)
		# else
		# 	file = Spreadsheet.open("public/"+tmp.original_filename)
		# end
		file = Spreadsheet.open("public/"+tmp.original_filename)
		sheet = file.worksheet(0)
		row1 = sheet.row(0)
		Return_Plan.transaction do
			sheet.each  do |row|
				if row[0]=="物料长代码"
					@rp_info = Rp_Info.new
					puts Time.new.strftime("%Y-%m-%d %H:%M:%S")
					@rp_info.create_time = DateTime.parse Time.new.strftime("%Y-%m-%d %H:%M:%S").to_s
					@rp_info.week1 = row[4]
					@rp_info.week2 = row[5]
					@rp_info.week3 = row[6]
					@rp_info.week4 = row[7]
					@rp_info.week5 = row[8]
					@rp_info.week6 = row[9]
					@rp_info.week7 = row[10]
					@rp_info.week8 = row[11]
					@rp_info.week9 = row[12]
					@rp_info.week10 = row[13]
					@rp_info.week11 = row[14]
					@rp_info.save
				else
					rp = Return_Plan.new
					rp.info_id = @rp_info.id
					rp.fnumber = row[0]
					rp.fname = row[1]
					rp.buyer = row[2]
					rp.wendor = row[3]
					rp.week1 = row[4]
					rp.week2 = row[5]
					rp.week3 = row[6]
					rp.week4 = row[7]
					rp.week5 = row[8]
					rp.week6 = row[9]
					rp.week7 = row[10]
					rp.week8 = row[11]
					rp.week9 = row[12]
					rp.week10 = row[13]
					rp.week11 = row[14]
					rp.save
				end
			end
		end
		File.delete("public/"+tmp.original_filename)
		render :text => tmp.original_filename
	end

	def index
		if power(T_K3_Auth, "t_return_auth")
			id = params[:id]
			if id
				@rp=Rp_Info.find(id)
				render :json => @rp
			else
				@rp=Rp_Info.order(create_time: :desc).first
				render :json => @rp
			end
		else
			return nopower!
		end
	end

	def info
		@rs = params[:rs]
		id = @rs[:id]
		week1 = @rs[:week1]
		week2 = @rs[:week2]
		week3 = @rs[:week3]
		week4 = @rs[:week4]
		week5 = @rs[:week5]
		week6 = @rs[:week6]
		week7 = @rs[:week7]
		week8 = @rs[:week8]
		week9 = @rs[:week9]
		week10 = @rs[:week10]
		week11 = @rs[:week11]
		weeek10 = @rs[:week10]
		weeek11 = @rs[:week11]
		week1_1 = (Date.parse(week1)+1).to_s
		week2_1 = (Date.parse(week2)+1).to_s
		week3_1 = (Date.parse(week3)+1).to_s
		week4_1 = (Date.parse(week4)+1).to_s
		week5_1 = (Date.parse(week5)+1).to_s
		week6_1 = (Date.parse(week6)+1).to_s
		week7_1 = (Date.parse(week7)+1).to_s
		week8_1 = (Date.parse(week8)+1).to_s
		week9_1 = (Date.parse(week9)+1).to_s
		week10_1 = (Date.parse(week10)+1).to_s
		week11_1 = (Date.parse(week11)+1).to_s
		
		today = Time.new.strftime("%Y-%m-%d")

		@plan = Return_Plan.find_by_sql("exec GIMS_RP_RQty '"+week1+"','"+week1+"','"+week1_1+"','"+week2+"','"+week2_1+"','"+week3+"','"+week3_1+"','"+week4+"','"+week4_1+"','"+week5+"','"+week5_1+"','"+week6+"','"+week6_1+"','"+week7+"','"+week7_1+"','"+week8+"','"+week8_1+"','"+week9+"','"+week9_1+"','"+week10+"','"+week10_1+"','"+week11_1+"',"+id)
		render :json => {:data =>@plan }
	end

	def time
		# starttime = params[:starttime]
		# endtime = params[:endtime]
		if power(T_K3_Auth, "t_return_auth")
			@rp = Rp_Info.where("create_time >= :starttime and create_time <= :endtime",{starttime: params[:starttime],endtime: params[:endtime]})
			render :json =>{:data =>@rp}
		else
			return nopower!
		end
	end

	def excel
		tmp = params[:file]
		require 'fileutils' #ruby老版本可尝试改为 require 'ftools'
		require "spreadsheet" #打开excel文件
		file = File.join("public", tmp.original_filename)
		FileUtils.cp tmp.path, file
		Spreadsheet.client_encoding = 'UTF-8'
		file = Spreadsheet.open("public/"+tmp.original_filename)
		sheet = file.worksheet(0)
		row1 = sheet.row(0)
		arr = Array.new
		# File.delete("public/"+tmp.original_filename)
		# s = ''
		# arr = Array.new
		i =0
		sheet.each  do |row|
			if row[0]==nil
			else
				# arr[i] = Hash.new 
				# arr[i]['物料长代码'] = row[0]
				# arr[i]['物料名称'] = row[1]
				# arr[i]['大事'] = row[6].value()
				# puts row[6].value()
				# arr[i]['但萨达'] = row[7]
				i +=1
			end
		end
		for k in 0..row1.length-1
			row1[k]=row1[k].to_s
		end
		for j in 0..i/3-1
			arr[j] = Hash.new 
			arr[j]['物料长代码'] = sheet.row(j*3+1)[0]
			arr[j]['物料名称'] = sheet.row(j*3+1)[1]
			arr[j]['w1_1'] = sheet.row(j*3+1)[6]
			arr[j]['w1_2'] = sheet.row(j*3+2)[6]
			arr[j]['w1_3'] = sheet.row(j*3+3)[6]
			if sheet.row(j*3+1)[6]>sheet.row(j*3+2)[6]
				arr[j]['w1_4'] = sheet.row(j*3+1)[6]
			else
				arr[j]['w1_4'] = sheet.row(j*3+2)[6]
			end
			arr[j]['w2_1'] = sheet.row(j*3+1)[7]
			arr[j]['w2_2'] = sheet.row(j*3+2)[7]
			arr[j]['w2_3'] = sheet.row(j*3+3)[7]
			arr[j]['w2_4'] = num(sheet,sheet.row(j*3+1)[7],sheet.row(j*3+2)[7],sheet.row(j*3+3)[7],j,7)
			arr[j]['w3_1'] = sheet.row(j*3+1)[8]
			arr[j]['w3_2'] = sheet.row(j*3+2)[8]
			arr[j]['w3_3'] = sheet.row(j*3+3)[8]
			arr[j]['w3_4'] = num(sheet,sheet.row(j*3+1)[8],sheet.row(j*3+2)[8],sheet.row(j*3+3)[8],j,8)
			arr[j]['w4_1'] = sheet.row(j*3+1)[9]
			arr[j]['w4_2'] = sheet.row(j*3+2)[9]
			arr[j]['w4_3'] = sheet.row(j*3+3)[9]
			arr[j]['w4_4'] = num(sheet,sheet.row(j*3+1)[9],sheet.row(j*3+2)[9],sheet.row(j*3+3)[9],j,9)
			arr[j]['w5_1'] = sheet.row(j*3+1)[10]
			arr[j]['w5_2'] = sheet.row(j*3+2)[10]
			arr[j]['w5_3'] = sheet.row(j*3+3)[10]
			arr[j]['w5_4'] = num(sheet,sheet.row(j*3+1)[10],sheet.row(j*3+2)[10],sheet.row(j*3+3)[10],j,10)
			arr[j]['w6_1'] = sheet.row(j*3+1)[11]
			arr[j]['w6_2'] = sheet.row(j*3+2)[11]
			arr[j]['w6_3'] = sheet.row(j*3+3)[11]
			arr[j]['w6_4'] = num(sheet,sheet.row(j*3+1)[11],sheet.row(j*3+2)[11],sheet.row(j*3+3)[11],j,11)
			arr[j]['w7_1'] = sheet.row(j*3+1)[12]
			arr[j]['w7_2'] = sheet.row(j*3+2)[12]
			arr[j]['w7_3'] = sheet.row(j*3+3)[12]
			arr[j]['w7_4'] = num(sheet,sheet.row(j*3+1)[12],sheet.row(j*3+2)[12],sheet.row(j*3+3)[12],j,12)
			arr[j]['w8_1'] = sheet.row(j*3+1)[13]
			arr[j]['w8_2'] = sheet.row(j*3+2)[13]
			arr[j]['w8_3'] = sheet.row(j*3+3)[13]
			arr[j]['w8_4'] = num(sheet,sheet.row(j*3+1)[13],sheet.row(j*3+2)[13],sheet.row(j*3+3)[13],j,13)
			arr[j]['w9_1'] = sheet.row(j*3+1)[14]
			arr[j]['w9_2'] = sheet.row(j*3+2)[14]
			arr[j]['w9_3'] = sheet.row(j*3+3)[14]
			arr[j]['w9_4'] = num(sheet,sheet.row(j*3+1)[14],sheet.row(j*3+2)[14],sheet.row(j*3+3)[14],j,14)
			arr[j]['w10_1'] = sheet.row(j*3+1)[15]
			arr[j]['w10_2'] = sheet.row(j*3+2)[15]
			arr[j]['w10_3'] = sheet.row(j*3+3)[15]
			arr[j]['w10_4'] = num(sheet,sheet.row(j*3+1)[15],sheet.row(j*3+2)[15],sheet.row(j*3+3)[15],j,15)
			arr[j]['w11_1'] = sheet.row(j*3+1)[16]
			arr[j]['w11_2'] = sheet.row(j*3+2)[16]
			arr[j]['w11_3'] = sheet.row(j*3+3)[16]
			arr[j]['w11_4'] = num(sheet,sheet.row(j*3+1)[16],sheet.row(j*3+2)[16],sheet.row(j*3+3)[16],j,16)
			arr[j]['w12_1'] = sheet.row(j*3+1)[17]
			arr[j]['w12_2'] = sheet.row(j*3+2)[17]
			arr[j]['w12_3'] = sheet.row(j*3+3)[17]
			arr[j]['w12_4'] = num(sheet,sheet.row(j*3+1)[17],sheet.row(j*3+2)[17],sheet.row(j*3+3)[17],j,17)
			arr[j]['w13_1'] = sheet.row(j*3+1)[18]
			arr[j]['w13_2'] = sheet.row(j*3+2)[18]
			arr[j]['w13_3'] = sheet.row(j*3+3)[18]
			arr[j]['w13_4'] = num(sheet,sheet.row(j*3+1)[18],sheet.row(j*3+2)[18],sheet.row(j*3+3)[18],j,18)
			arr[j]['w14_1'] = sheet.row(j*3+1)[19]
			arr[j]['w14_2'] = sheet.row(j*3+2)[19]
			arr[j]['w14_3'] = sheet.row(j*3+3)[19]
			arr[j]['w14_4'] = num(sheet,sheet.row(j*3+1)[19],sheet.row(j*3+2)[19],sheet.row(j*3+3)[19],j,19)
			arr[j]['w15_1'] = sheet.row(j*3+1)[20]
			arr[j]['w15_2'] = sheet.row(j*3+2)[20]
			arr[j]['w15_3'] = sheet.row(j*3+3)[20]
			arr[j]['w15_4'] = num(sheet,sheet.row(j*3+1)[20],sheet.row(j*3+2)[20],sheet.row(j*3+3)[20],j,20)
		end
		render :json => {:data1 =>arr,:data2 =>row1}
	end

	def num(sheet,num1,num2,num3,j,index)
		if num3>0
			if num2>0
				return sheet.row(j*3+2)[index-1]
			else
				return 0
			end
		else
			if num3==0
				if num2>0
					if sheet.row(j*3+2)[index-1]>sheet.row(j*3+1)[index-1]
						return sheet.row(j*3+2)[index-1]
					else
						return sheet.row(j*3+1)[index-1]
					end
				else
					return 0
				end
			else
				return sheet.row(j*3+1)[index]-sheet.row(j*3+3)[index-1]
			end 
		end
	end

end