class ZxhubController < ApplicationController
	before_action :authentication
	def load
        if power(T_K3_Auth, "t_zxhub_auth")
            cwcxsel = params[:cwcxsel]
            sqlCwcxsel = "";
            if cwcxsel&&(""!=cwcxsel)&&("all"!=cwcxsel)
                @a = Zxhub.where("address = ?",cwcxsel);
            else 
                @a = Zxhub.all;
            end
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end

	def delete
		if power(T_K3_Auth, "t_zxhub_auth")
        	id = params[:id];
            if Zxhub.delete(id)
                render :text => "删除成功";
            else
                render :text => "删除失败";
            end
        else
            return nopower!;           
        end
	end

	def save		
		if power(T_K3_Auth, "t_zxhub_auth")
        	xh=params[:xh].lstrip.rstrip
			khdm=params[:khdm].lstrip.rstrip
			cw=params[:cw].lstrip.rstrip
        	zxhub = Zxhub.new;
        	zxhub.model = xh
        	zxhub.fnumber = khdm
        	zxhub.address = cw
        	if zxhub.save!
            	render :text => "保存成功";
        	else 
            	render :text => "保存失败";
            end
        else
        	return nopower!;
        end
	end
end