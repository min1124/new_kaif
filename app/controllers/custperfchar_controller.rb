class CustperfcharController < ApplicationController
	before_action :authentication, only:[:load ]
	def load
		name = params[:name];
		if "test"==name || "朱琳"==name || "曹林香"==name || "代芳"==name
			@a = Cust_Performance_Char.all;
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end

    def upload
        Cust_Performance_Char.delete_all();
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
            if row1[0] == "产品型号后缀编码"
                Bfdjprice.transaction do
                    sheet.each  do |row|
                        if row[0]=="产品型号后缀编码"

                        else
                            cust_Performance_Char = Cust_Performance_Char.new
                            cust_Performance_Char.product_model_suffix = row[row1.index("产品型号后缀编码")]
                            cust_Performance_Char.f_102 = row[row1.index("客户代码")]
                            cust_Performance_Char.add_date = row[row1.index("添加日期")]
                            cust_Performance_Char.add_reason = row[row1.index("添加原因")]
                            cust_Performance_Char.save
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