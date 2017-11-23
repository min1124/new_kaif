class FnumberdescController < ApplicationController
	before_action :authentication, only:[:load ]
	def load
		if power(T_K3_Auth, "t_fnumberdesc_auth")
			@a = Fnumber_Desc.all;
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end

    def upload
        #Fnumber_Desc.delete_all();
        tmp = params[:file]
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
            if row1[0] == "HG PN"
                Bfdjprice.transaction do
                    sheet.each  do |row|
                        if row[0]=="HG PN"

                        else
                            if nil != row[row1.index("CPN")]
                                customer_code = tmp.original_filename;
                                customer_code_str = customer_code.to_s[0,customer_code.length-13]
                                fnumber_Desc = Fnumber_Desc.new
                                fnumber_Desc.customer_code = customer_code_str
                                fnumber_Desc.customer_number = row[row1.index("CPN")]
                                fnumber_Desc.fnumber_desc = row[row1.index("DESC")]
                                fnumber_Desc.save
                            end
                        end
                    end
                end
                File.delete("public/"+tmp.original_filename)
                render :text  => '上传成功'
            else
                File.delete("public/"+tmp.original_filename)
                render :text  => '文件类型不匹配'
            end 
        end
    end
end