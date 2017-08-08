class FbillnoclosedController < ApplicationController
	before_action :authentication
	def load
		name = params[:name];
        if power(T_K3_Auth, "t_perfchar_auth")
            @a = Fbillno_Closed.all;
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end

	def save		
		name = params[:name];
        if power(T_K3_Auth, "t_perfchar_auth")
        	djbh = params[:djbh].lstrip.rstrip
        	fbillno_closed = Fbillno_Closed.new;
        	fbillno_closed.FBillNo = djbh
            today = Time.new
            fbillno_closed.create_date = today.strftime("%Y-%m-%d %H:%M:%S")
        	if fbillno_closed.save!
            	render :text => "保存成功";
        	else 
            	render :text => "保存失败";
            end
        else
        	return nopower!;
        end
	end
end