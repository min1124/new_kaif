class AsnlabelController < ApplicationController
	def upload
		tmp = params[:file]
		require 'fileutils' #ruby老版本可尝试改为 require 'ftools'
		require "spreadsheet" #打开excel文件
		file = File.join("public", tmp.original_filename)
		FileUtils.cp tmp.path, file
		Spreadsheet.client_encoding = 'UTF-8'
		file = Spreadsheet.open("public/"+tmp.original_filename)
		conn = ActiveRecord::Base.connection
		sheet1 = file.worksheet(0)
		sheet2 = file.worksheet(1)
		i =0
		sheet1.each  do |row|
			if row[0]==nil
			else
				i +=1
			end
		end
		arr = Array.new
		ActiveRecord::Base.transaction do
			for j in 1..i-1
				arr[j-1] = Hash.new  
				arr[j-1]['箱号'] = sheet2.row(j)[0]
				arr[j-1]['华为料号'] = sheet1.row(j)[0]
				arr[j-1]['物料名称'] = conn.select_all("select distinct(FMapName) from ICItemMapping where FMapNumber = '"+arr[j-1]['华为料号']+"'")[0]['FMapName']
				arr[j-1]['数量'] = sheet2.row(j)[5]
			end
		end
		render :json => arr
	end
end