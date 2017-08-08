class FnumberController < ApplicationController
	before_action :authentication, only:[:index,:save,:upd,:updSave,:del,:f102,:getfnumber,:fnumber,:productLine ]
	def index
		if power(T_K3_Auth, "t_fnumber_auth")
			@fnumber =  Cust_Fnumber.all
			render :json => {:data =>@fnumber} 
		else
			return nopower!
		end	
	end

	def save
		name = params[:name];
        if power(T_K3_Auth, "t_fnumber_auth")
        	source = params[:source]
        	sourceCode = params[:sourceCode].lstrip.rstrip
        	customerCode = params[:customerCode].lstrip.rstrip
        	customerName = params[:customerName].lstrip.rstrip
        	fnumber = params[:fnumber].lstrip.rstrip
        	productModelZy = params[:productModelZy].lstrip.rstrip
        	customerNumber = params[:customerNumber].lstrip.rstrip
			productModel = params[:productModel].lstrip.rstrip
			productLine = params[:productLine].lstrip.rstrip
			productStatus = params[:productStatus]
			shippingOrNot = params[:shippingOrNot]
			costPriority = params[:costPriority]
			f11 = params[:f11]
			kcxhjzDate = params[:kcxhjzDate]
			note = params[:note]

        	custFnumber = Cust_Fnumber.new;
        	custFnumber.source = source
        	custFnumber.source_code = sourceCode
        	custFnumber.customer_code = customerCode
        	custFnumber.customer_name = customerName
        	custFnumber.fnumber = fnumber
        	custFnumber.product_model_zy = productModelZy
        	custFnumber.customer_number = customerNumber
        	custFnumber.product_model = productModel
        	custFnumber.product_line = productLine
        	custFnumber.product_status = productStatus
        	custFnumber.shipping_or_not = shippingOrNot
        	custFnumber.cost_priority = costPriority
            today = Time.new
        	custFnumber.update_date1 = today.strftime("%Y-%m-%d %H:%M:%S")
        	custFnumber.F11 = f11
        	custFnumber.kcxhjz_date = kcxhjzDate
        	custFnumber.note = note
        	if custFnumber.save!
            	render :text => "保存成功";
        	else 
            	render :text => "保存失败";
            end
        else
        	return nopower!;
        end
	end

	def upd
		sql = params[:sql]
		@a = Cust_Fnumber.where("ID = ?",sql)
		render :json =>{:data1 =>@a}
	end

	def updSave
		if power(T_K3_Auth, "t_fnumber_auth")
			id = params[:id]
            custFnumber = Cust_Fnumber.find(id)

            custFnumberRec = Cust_Fnumber_Rec.new;
            custFnumberRec.ID = id
            custFnumberRec.source = custFnumber.source
            custFnumberRec.source_code = custFnumber.source_code
            custFnumberRec.customer_code = custFnumber.customer_code
            custFnumberRec.customer_name = custFnumber.customer_name
            custFnumberRec.fnumber = custFnumber.fnumber
            custFnumberRec.product_model_zy = custFnumber.product_model_zy
            custFnumberRec.customer_number = custFnumber.customer_number
            custFnumberRec.product_model = custFnumber.product_model
            custFnumberRec.product_line = custFnumber.product_line
            custFnumberRec.product_status = custFnumber.product_status
            custFnumberRec.shipping_or_not = custFnumber.shipping_or_not
            custFnumberRec.cost_priority = custFnumber.cost_priority
            custFnumberRec.update_date1 = custFnumber.update_date1
            custFnumberRec.F11 = custFnumber.F11
            custFnumberRec.kcxhjz_date = custFnumber.kcxhjz_date
            custFnumberRec.note = custFnumber.note
            custFnumberRec.save

			productStatus = params[:productStatus]
            shippingOrNot = params[:shippingOrNot]
            costPriority = params[:costPriority]
            f11 = params[:f11]
            kcxhjzDate = params[:kcxhjzDate]
            note = params[:note]

            custFnumber.product_status = productStatus
            custFnumber.shipping_or_not = shippingOrNot
            custFnumber.cost_priority = costPriority
            today = Time.new
            custFnumber.update_date1 = today.strftime("%Y-%m-%d %H:%M:%S")
            custFnumber.F11 = f11
            custFnumber.kcxhjz_date = kcxhjzDate
            custFnumber.note = note
        	if custFnumber.save!
            	render :text => "保存成功";
        	else 
            	render :text => "保存失败";
            end
        else
        	return nopower!;
        end
	end

	def del
		if power(T_K3_Auth, "t_fnumber_auth")
			id=params[:id]
			if Cust_Fnumber.delete(id)
                render :text => "删除成功";
            else
                render :text => "删除失败";
            end
        else
            return nopower!
        end
  	end

    def getfnumber
    	@b = ActiveRecord::Base.connection.select_all("Select distinct(t2.FNumber) as 物料代码 
            From ICItemMapping t1, t_ICItem t2, t_Organization t3
            Where t1.FItemID=t2.FItemID And t1.FPropertyID=1  And t2.FDeleted=0  
            And t1.FCompanyID=t3.FItemID And t1.FCompanyID in (
                select FItemID from t_Organization where fnumber like '%A.%' and fitemid<>'71086'
            ) group by t2.FNumber Order by 物料代码")
		render :json =>{:data =>@b}
    end

    def checkFnumber
        sql = params[:sql]
        @custFnumber = Cust_Fnumber.find_by_sql("select ID from cust_fnumbers where fnumber = '"+sql+"'");
        if nil != @custFnumber && @custFnumber.length > 0
            render :text => "1";
        else
            render :text => "0";
        end
    end

    def fnumber
		sql = params[:sql]
        @custPerformanceChar = Cust_Performance_Char.find_by_sql("select 客户代码C, 物料代码, 
            物料名称, 客户代码, 客户型号 from V_Fnumber where 物料代码 = '"+sql+"'")
        render :json =>{:data =>@custPerformanceChar}
	end

    def customerCode
        sql = params[:sql]
        @fName = ActiveRecord::Base.connection.select_all("select FName as 客户名称C from t_Organization 
            where fnumber like '%A.%' and fitemid<>'71086' and fitemid<>'71087' and F_102 = '"+sql+"'")
        render :json =>{:data1 =>@fName}
    end

	def productLine
		sql = params[:sql]
		@a = ActiveRecord::Base.connection.select_all("select finterid as 内码, FId, Fname from t_submessage where FParentID=504")
		render :json =>{:data =>@a}
	end

    def updQuery
        sqlId = params[:sqlId]
        sqlFnumber = params[:sqlFnumber]
        @custFnumberRec = Cust_Fnumber_Rec.where("ID = '#{sqlId}' and fnumber = '#{sqlFnumber}'").order("ID_Cust DESC")
        render :json =>{:data =>@custFnumberRec}
    end

    def upload
        Cust_Fnumber.delete_all();
        tmp = params[:file]
        today = Time.new
        # time = today.strftime("%Y-%m-%d %H:%M:%S")
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
            if row1[0] == "ID"
                Cust_Fnumber.transaction do
                    sheet.each  do |row|
                        if row[0]=="ID"

                        else
                            fnumber = row[row1.index("产品代码")]
                            if(fnumber && (""!=fnumber))
                                @custFnumber = Cust_Fnumber.find_by_sql("select ID from cust_fnumbers where fnumber = '"+fnumber+"'");
                                if nil != @custFnumber && @custFnumber.length > 0
                                    render :text  => "上传失败，#{fnumber}已存在！";
                                else
                                    custFnumber = Cust_Fnumber.new;
                                    custFnumber.source = row[row1.index("来源")]
                                    custFnumber.source_code = row[row1.index("来源编号")]
                                    custFnumber.product_line = row[row1.index("产品线")]
                                    custFnumber.product_status = row[row1.index("产品状态")]
                                    custFnumber.shipping_or_not = row[row1.index("是否可发货")]
                                    custFnumber.cost_priority = row[row1.index("成本优先级")]
                                    update_date1 = row[row1.index("新增日期")]
                                    if(update_date1 && (""!=update_date1))
                                        custFnumber.update_date1 = update_date1.strftime("%Y-%m-%d %H:%M:%S")
                                    end
                                    custFnumber.F11 = row[row1.index("修订内容")]
                                    custFnumber.kcxhjz_date = row[row1.index("库存消耗截止日期")]
                                    custFnumber.note = row[row1.index("备注")]

                                    custFnumber.fnumber = fnumber#产品代码

                                    @custPerformanceChar = Cust_Performance_Char.find_by_sql("select 客户代码C, 物料代码, 
                                        物料名称, 客户代码, 客户型号 from V_Fnumber where 物料代码 = '"+fnumber+"'")
                                    if nil != @custPerformanceChar && @custPerformanceChar.length > 0
                                        if @custPerformanceChar.length == 1
                                            customer_code = @custPerformanceChar[0].客户代码C

                                            custFnumber.product_model_zy = @custPerformanceChar[0].物料名称#
                                            custFnumber.customer_number = @custPerformanceChar[0].客户代码#           
                                            custFnumber.product_model = @custPerformanceChar[0].客户型号#

                                            if(customer_code && (""!=customer_code))
                                                custFnumber.customer_code = customer_code#
                                                @fName = ActiveRecord::Base.connection.select_all("select FName as 客户名称C 
                                                    from t_Organization where fnumber like '%A.%' and fitemid<>'71086' 
                                                    and fitemid<>'71087' and F_102 = '"+customer_code+"'")
                                                if nil != @fName[0] && @fName[0].length > 0
                                                    if @fName[0].length == 1
                                                        custFnumber.customer_name = @fName[0]["客户名称C"]#
                                                        custFnumber.save!
                                                    else
                                                        render :text  => "上传失败！客户代码#{customer_code}存在多个客户名称，请核实！";
                                                    end
                                                end
                                            else
                                                custFnumber.save!
                                            end
                                        end
                                    else
                                        custFnumber.save!
                                    end                                    
                                end
                            else
                                #render :text  => '上传失败，产品代码不能为空！';
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