class FnumberController < ApplicationController
	before_action :authentication
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
        	customerNumber = params[:customerNumber].lstrip.rstrip
			productModel = params[:productModel].lstrip.rstrip
			fnumber = params[:fnumber].lstrip.rstrip
			customerCode = params[:customerCode].lstrip.rstrip
			productLine = params[:productLine].lstrip.rstrip
			customerName = params[:customerName].lstrip.rstrip
			productStatus = params[:productStatus]
			shippingOrNot = params[:shippingOrNot]
			updateDate = params[:updateDate]
			f11 = params[:f11]
        	custFnumber = Cust_Fnumber.new;
        	custFnumber.customer_number = customerNumber
        	custFnumber.product_model = productModel
        	custFnumber.fnumber = fnumber
        	custFnumber.customer_code = customerCode
        	custFnumber.product_line = productLine
        	custFnumber.customer_name = customerName
        	custFnumber.product_status = productStatus
        	custFnumber.shipping_or_not = shippingOrNot
        	custFnumber.update_date = updateDate
        	custFnumber.F11 = f11
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
			productStatus = params[:productStatus]
			shippingOrNot = params[:shippingOrNot]
			updateDate = params[:updateDate]
			f11 = params[:f11]
			custFnumber = Cust_Fnumber.find(id)
			custFnumber.product_status = productStatus
        	custFnumber.shipping_or_not = shippingOrNot
        	custFnumber.update_date = updateDate
        	custFnumber.F11 = f11
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
end