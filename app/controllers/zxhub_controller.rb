class ZxhubController < ApplicationController
	before_action :authentication
	def load
		name = params[:name];
		if "车琳"==name
            cwcxsel = params[:cwcxsel]
            sqlCwcxsel = "";
            if cwcxsel&&(""!=cwcxsel)
                case cwcxsel
                    when "all"
                        @a = Zxhub.all;
                    when "VMI"
                        @a = Zxhub.where("address = ?","VMI");
                    when "BHUB"
                        @a = Zxhub.where("address = ?","BHUB");
                    when "B"
                        @a = Zxhub.where("address = ?","B");
                end
            else 
                @a = Zxhub.all;
            end
			
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end

	def delete
		name = params[:name];
		if "车琳"==name
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
		name = params[:name];
        if "车琳"==name
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