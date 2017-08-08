class BfpriceController < ApplicationController
	before_action :authentication, only:[:load ]
	def load
		name = params[:name];
		if "李永青"==name || "test"==name
			@a = Bfdjprice.all;
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end

    def upload
        Bfdjprice.delete_all();
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
            if row1[0] == "物料代码"
                Bfdjprice.transaction do
                    sheet.each  do |row|
                        if row[0]=="物料代码"

                        else
                            bfdjprice = Bfdjprice.new
                            bfdjprice.FEntryNumber = row[row1.index("物料代码")]
                            bfdjprice.FRejClass = row[row1.index("报废类别")]
                            bfdjprice.RejAmountDJ = row[row1.index("单价")]
                            bfdjprice.UploadDate = time
                            bfdjprice.save
                        end
                    end
                end
                File.delete("public/"+tmp.original_filename)
                render :text  => '上传成功'
            else
                File.delete("public/"+tmp.original_filename)
                render :text  => '文件类型不匹配,请选择对应的客户'
            end 
        end
    end
end