class KeyfnumbersController < ApplicationController
	before_action :authentication, only:[:load ]
	def load
        if power(T_K3_Auth, "t_keyfnumbers_auth")    
			@a = Key_Fnumbers.all;
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end

    def upload
        Key_Fnumbers.delete_all();
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
            if row1[0] == "项目"
                Bfdjprice.transaction do
                    sheet.each  do |row|
                        if row[0]=="项目"

                        else
                            key_fnumbers = Key_Fnumbers.new
                            key_fnumbers.project = row[row1.index("项目")]
                            key_fnumbers.fnumber = row[row1.index("物料长代码")]
                            key_fnumbers.fname = row[row1.index("物料名称")]
                            key_fnumbers.fmodel = row[row1.index("规格型号")]
                            key_fnumbers.wendor = row[row1.index("wendor")]
                            key_fnumbers.category = row[row1.index("类别")]
                            key_fnumbers.lt_y = row[row1.index("有预测LT")]
                            key_fnumbers.lt_n = row[row1.index("无预测LT")]
                            key_fnumbers.save
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