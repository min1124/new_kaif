class DelayordericmoController < ApplicationController
	before_action :authentication
	def load
        if power(T_K3_Auth, "t_zxhub_auth")
            sqlFBillNo = "";
            fBillNo=params[:fBillNo]
            if fBillNo&&(""!=fBillNo)
                sqlFBillNo = " where fBillNo = '"+fBillNo+"'";
            end
            @a = DelayOrderIcmo.find_by_sql("select Id,fBillNo,Maker,convert(varchar,fdate,120) as Fdate,flag from DelayOrderWithOutICMO" + sqlFBillNo);
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end

	def save		
		if power(T_K3_Auth, "t_zxhub_auth")
        	fBillNo=params[:fBillNo].lstrip.rstrip
			name=params[:name].lstrip.rstrip
        	delayOrderFnumber = DelayOrderIcmo.new;
        	delayOrderFnumber.fBillNo = fBillNo
        	delayOrderFnumber.Maker = name
            time = Time.new
            delayOrderFnumber.fdate = time
            delayOrderFnumber.flag = 1
        	if delayOrderFnumber.save!
            	render :text => "保存成功";
        	else 
            	render :text => "保存失败";
            end
        else
        	return nopower!;
        end
	end

    def updsave        
        if power(T_K3_Auth, "t_zxhub_auth")
            time = Time.now()
            name = params[:name]
            id = params[:id]
            flag = params[:flag]
            delayOrderFnumber = DelayOrderIcmo.find(id);
            delayOrderFnumber.Maker = name
            delayOrderFnumber.fdate = time
            delayOrderFnumber.flag = flag
            if delayOrderFnumber.save!
                render :text => "保存成功";
            else 
                render :text => "保存失败";
            end
        else
            return nopower!;
        end
    end
end