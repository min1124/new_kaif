class DelayorderfnumberController < ApplicationController
	before_action :authentication
	def load
        if power(T_K3_Auth, "t_zxhub_auth")
            sqlFNumber = "";
            fNumber=params[:fNumber]
            if fNumber&&(""!=fNumber)
                sqlFNumber = " where fNumber = '"+fNumber+"'";
            end
            @a = DelayOrderFnumber.find_by_sql("select Id,fNumber,Maker,convert(varchar,fdate,120) as Fdate,flag from DelayOrderWithOutFNumber" + sqlFNumber);
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end

	def save		
		if power(T_K3_Auth, "t_zxhub_auth")
        	fNumber=params[:fNumber].lstrip.rstrip
			name=params[:name].lstrip.rstrip
        	delayOrderFnumber = DelayOrderFnumber.new;
        	delayOrderFnumber.fNumber = fNumber
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
            delayOrderFnumber = DelayOrderFnumber.find(id);
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