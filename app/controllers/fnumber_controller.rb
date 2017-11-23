class FnumberController < ApplicationController
	before_action :authentication, only:[:index,:save,:upd,:updSave,:del,:f102,:getfnumber,:fnumber,:productLine ]
	def index
		if power(T_K3_Auth, "t_fnumberhw_auth")
			@fnumber =  Cust_Fnumber.find_by_sql("select * from cust_fnumbers where customer_code like 'HN-02%'")
			render :json => {:data =>@fnumber} 
		else
			return nopower!
		end	
	end

	def save
		name = params[:name];
        if power(T_K3_Auth, "t_fnumberhw_auth")
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
		if power(T_K3_Auth, "t_fnumberhw_auth")
			id = params[:id]
            custFnumber = Cust_Fnumber.find(id)

            cust_Fnumber_Rec = Cust_Fnumber_Rec.new
            cust_Fnumber_Rec.ID = custFnumber.ID
            cust_Fnumber_Rec.source = custFnumber.source
            cust_Fnumber_Rec.source_code = custFnumber.source_code
            cust_Fnumber_Rec.customer_code = custFnumber.customer_code
            cust_Fnumber_Rec.customer_name = custFnumber.customer_name
            cust_Fnumber_Rec.fnumber = custFnumber.fnumber
            cust_Fnumber_Rec.product_model_zy = custFnumber.product_model_zy
            cust_Fnumber_Rec.customer_number = custFnumber.customer_number
            cust_Fnumber_Rec.product_model = custFnumber.product_model
            cust_Fnumber_Rec.product_line = custFnumber.product_line
            cust_Fnumber_Rec.product_status = custFnumber.product_status
            cust_Fnumber_Rec.pcn_flag = custFnumber.pcn_flag
            cust_Fnumber_Rec.pcn_date = custFnumber.pcn_date
            cust_Fnumber_Rec.shipping_or_not = custFnumber.shipping_or_not
            cust_Fnumber_Rec.cost_priority = custFnumber.cost_priority
            cust_Fnumber_Rec.update_date1 = custFnumber.update_date1
            cust_Fnumber_Rec.F11 = custFnumber.F11
            cust_Fnumber_Rec.kcxhjz_date = custFnumber.kcxhjz_date
            cust_Fnumber_Rec.note = custFnumber.note
            cust_Fnumber_Rec.save

			productStatus = params[:productStatus]
            pcnFlag = params[:pcnFlag]
            pcnDate = params[:pcnDate]
            shippingOrNot = params[:shippingOrNot]
            costPriority = params[:costPriority]
            f11 = params[:f11]
            kcxhjzDate = params[:kcxhjzDate]
            note = params[:note]

            custFnumber.product_status = productStatus
            custFnumber.pcn_flag = pcnFlag
            custFnumber.pcn_date = pcnDate
            custFnumber.shipping_or_not = shippingOrNot
            custFnumber.cost_priority = costPriority
            today = Time.new
            custFnumber.update_date1 = today.strftime("%Y-%m-%d %H:%M:%S")
            custFnumber.F11 = f11
            custFnumber.kcxhjz_date = kcxhjzDate
            custFnumber.note = note
        	if custFnumber.save!
            	render :text => 0;
        	else 
            	render :text => 1;
            end
        else
        	return nopower!;
        end
	end

	def del
		if power(T_K3_Auth, "t_fnumberhw_auth")
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
    	# @b = ActiveRecord::Base.connection.select_all("Select distinct(t2.FNumber) as 物料代码 
     #        From ICItemMapping t1, t_ICItem t2, t_Organization t3
     #        Where t1.FItemID=t2.FItemID And t1.FPropertyID=1  And t2.FDeleted=0  
     #        And t1.FCompanyID=t3.FItemID And t1.FCompanyID in (
     #            select FItemID from t_Organization where fnumber like '%A.%' and fitemid<>'71086'
     #        ) group by t2.FNumber Order by 物料代码")
        @b = ActiveRecord::Base.connection.select_all("select fnumber as 物料代码 from t_icitem
                where fdeleted=0 and (fnumber like '04.%' or fnumber like '05.%') Order by fnumber")
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
        # @custPerformanceChar = Cust_Performance_Char.find_by_sql("select 客户代码C, 物料代码, 
        #     物料名称, 客户代码, 客户型号 from V_Fnumber where 物料代码 = '"+sql+"'")
        @custPerformanceCharA = Cust_Performance_Char.find_by_sql("select t1.f_102 AS 客户代码 ,t2.* 
                from ( SELECT * from V_Fnumber where 物料代码 = '"+sql+"') t2
                left join cust_performance_char t1 on t1.product_model_suffix = t2.f102")
        @custPerformanceCharB = Cust_Performance_Char.find_by_sql("SELECT * 
                from V_FnumberFMapName where 物料代码 = '"+sql+"' ")
        render :json =>{:dataA =>@custPerformanceCharA, :dataB =>@custPerformanceCharB}
	end

    def customerCode
        sql = params[:sql]
        @fName = ActiveRecord::Base.connection.select_all("select FName as 客户名称 from t_Organization 
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
        @custFnumberRec = Cust_Fnumber_Rec.where(ID:sqlId,fnumber:sqlFnumber).order("ID_Cust DESC")
        render :json =>{:data =>@custFnumberRec}
    end

    def fnumberselect
        customer_number = params[:customer_number]
        # shipping_or_not = 'Y' and
        @fnumbers = Cust_Fnumber.find_by_sql("select fnumber from cust_fnumbers where customer_number = '"+customer_number+"'")
        render :json =>{:data =>@fnumbers}
    end

    def fnumberselchange
        name = params[:name]
        customer_number = params[:customer_number]
        fnumberSelect = params[:fnumberSelect]
        productModelHw = params[:productModelHw]
        fnumberDescHw = params[:fnumberDescHw]
        keyBomFnumber = params[:keyBomFnumber]
        
        @fnumbers = Cust_Fnumber.where(customer_number:customer_number)
        for i in 0..@fnumbers.length-1
            @fnumbers[i].fnumber_hw = fnumberSelect
            @fnumbers[i].fnumber_desc = fnumberDescHw
            @fnumbers[i].key_fnumbers = keyBomFnumber
            @fnumbers[i].save
        end

        keyfnumbers = Array.new 
        if(keyBomFnumber && (""!=keyBomFnumber))
            keyfnumbers = keyBomFnumber.split(',')
        end

        @keyfnumbersSelect = Bom_Key_Fnumbers.where(customer_number:customer_number,close_flag:"Y")
        if nil == @keyfnumbersSelect || @keyfnumbersSelect.length == 0
            createBomKey(name,customer_number,fnumberSelect,productModelHw,keyfnumbers)
        elsif @keyfnumbersSelect[0].fnumber_hw != fnumberSelect
            for i in 0..@keyfnumbersSelect.length-1
                @keyfnumbersSelect[i].close_flag = "N"
                @keyfnumbersSelect[i].save
            end
            createBomKey(name,customer_number,fnumberSelect,productModelHw,keyfnumbers)
        else
            @bom_key_fnumbers = Bom_Key_Fnumbers.where(customer_number:customer_number,
                close_flag:"Y").pluck(:key_fnumber).uniq()
            old_bom_key = @bom_key_fnumbers - keyfnumbers
            new_bom_key = keyfnumbers - @bom_key_fnumbers

            puts "old_bom_key=#{old_bom_key}"
            @bom_key_fnumbers1 = Bom_Key_Fnumbers.where(customer_number: customer_number,close_flag: "Y",key_fnumber: old_bom_key)
            for i in 0..@bom_key_fnumbers1.length-1
                @bom_key_fnumbers1[i].close_flag = "N"
                @bom_key_fnumbers1[i].save
            end
            puts "new_bom_key=#{new_bom_key}"
            createBomKey(name,customer_number,fnumberSelect,productModelHw,new_bom_key)
        end
        render :text => 0
    end

    def createBomKey(name,customer_number,fnumberSelect,productModelHw,keyfnumbers)
        @fnumbers = Cust_Fnumber.find_by_sql("select fnumber 
            from cust_fnumbers where shipping_or_not = 'Y' 
            and customer_number = '"+customer_number+"'")
        today = Time.new
        for i in 0..@fnumbers.length-1
            for j in 0..keyfnumbers.length-1
                bom_Key_Fnumbers = Bom_Key_Fnumbers.new
                bom_Key_Fnumbers.customer_number = customer_number 
                bom_Key_Fnumbers.fnumber_hw = fnumberSelect
                bom_Key_Fnumbers.fnumber_y = @fnumbers[i].fnumber
                bom_Key_Fnumbers.product_model = productModelHw
                bom_Key_Fnumbers.key_fnumber = keyfnumbers[j]

                if @fnumbers[i].fnumber == fnumberSelect
                    bom_Key_Fnumbers.key_fnumber_sel = keyfnumbers[j]
                    @b = Bom_Key_Fnumbers.find_by_sql("exec KeyBomFnumbersChildWeight "+ "'"+fnumberSelect+"','"+keyfnumbers[j]+"'") 
                    if nil != @b && @b.length > 0
                        bom_Key_Fnumbers.child_weitht = @b[0].单位用量
                    end
                end

                @key_Fnumbers = Key_Fnumbers.where(fnumber:keyfnumbers[j])
                if nil != @key_Fnumbers && @key_Fnumbers.length > 0
                    bom_Key_Fnumbers.product_line = @key_Fnumbers[0].category
                end

                @fName = ActiveRecord::Base.connection.select_all("SELECT FName AS 物料名称 
                    FROM t_ICItem WHERE FDeleted = 0 and FNumber  = '"+keyfnumbers[j]+"'")
                if nil != @fName && @fName[0].length >0
                    bom_Key_Fnumbers.fnumber_desc = @fName[0]['物料名称']
                end
                bom_Key_Fnumbers.create_date = today.strftime("%Y-%m-%d %H:%M:%S")
                bom_Key_Fnumbers.create_emp = name
                bom_Key_Fnumbers.close_flag = "Y"
                bom_Key_Fnumbers.save
            end
        end
    end

    def fnumberdesc
        fnumberSelHw = params[:fnumberSelHw]
        @fnumbersHw = Cust_Fnumber.find_by_sql("select customer_code,customer_number from cust_fnumbers where fnumber = '"+fnumberSelHw+"'")
        customer_code = @fnumbersHw[0].customer_code;
        customer_number = @fnumbersHw[0].customer_number;
        
        @fnumber_desc = Fnumber_Desc.where(customer_number:customer_number,customer_code:customer_code)
        # if nil != @fnumber_desc && @fnumber_desc.length > 0
        #     fnumber_desc = @fnumber_desc[0].fnumber_desc
        # else
        #     fnumber_desc = ""
        # end
        #@fnumber_desc = Fnumber_Desc.where(:customer_number => customer_number,:customer_code => customer_code)
        render :json => {:data =>@fnumber_desc}
    end

    def keyfnumber
        fnumber = params[:fnumber]
        @fnumber_desc = Key_Fnumbers.find_by_sql("exec KeyBomFnumbersKey '"+fnumber+"'")
        render :json => {:data =>@fnumber_desc}
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

                                    @custPerformanceChar = Cust_Performance_Char.find_by_sql("select t1.f_102 AS 客户代码 ,t2.* 
                                        from ( SELECT * from V_Fnumber where 物料代码 = '"+fnumber+"') t2
                                        left join cust_performance_char t1 on t1.product_model_suffix = t2.f102")
                                    if nil != @custPerformanceChar && @custPerformanceChar.length > 0
                                        if @custPerformanceChar.length == 1
                                            custFnumber.product_model_zy = @custPerformanceChar[0].物料名称#

                                            customer_code = @custPerformanceChar[0].客户代码
                                            if(customer_code && (""!=customer_code) && ("我司标准产"!=customer_code))
                                                custFnumber.customer_code = customer_code#

                                                @fName = Cust_Performance_Char.find_by_sql("select * from V_Organization 
                                                    where F_102 = '"+customer_code+"'")
                                                if nil != @fName && @fName.length > 0
                                                    if @fName.length == 1
                                                        fitemid = @fName[0].客户内码
                                                        if(fitemid && (""!=fitemid))
                                                            @custPerformanceChar1 = Cust_Performance_Char.find_by_sql("SELECT * 
                                                                from V_FnumberFMapName where 物料代码 = '"+fnumber+"' and 客户内码 = '"+fitemid.to_s+"'")
                                                            if nil != @custPerformanceChar1 && @custPerformanceChar1.length > 0
                                                                if @custPerformanceChar1.length == 1
                                                                    custFnumber.customer_number = @custPerformanceChar1[0].客户代码#           
                                                                    custFnumber.product_model = @custPerformanceChar1[0].客户型号#  
                                                                else
                                                                    custFnumber.save!
                                                                end
                                                            else
                                                                custFnumber.save!
                                                            end
                                                        else
                                                            custFnumber.save!
                                                        end
                                                        custFnumber.customer_name = @fName[0].客户名称#
                                                        custFnumber.save!
                                                    else
                                                        custFnumber.save!
                                                    end
                                                else
                                                    custFnumber.save!
                                                end
                                            else
                                                custFnumber.save!
                                            end
                                        else
                                            custFnumber.save!
                                        end
                                    else
                                        custFnumber.save!
                                    end                                  
                                end
                            else
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