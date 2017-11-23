class ReplaceController < ApplicationController
    before_action :authentication
	def index
        if power(T_K3_Auth, "t_replace_auth")
    		zldm = params[:zldm]
            tdldm = params[:tdldm]
            
            sql = "";
            if zldm&&(""!=zldm)
                sql += " and ZfNumber like '%"+zldm+"%'";
            end

            if tdldm&&(""!=tdldm)
                sql += " and TfNumber like '%"+tdldm+"%'";
            end

            @fnumber = Cust_Fnumber.find_by_sql("select * from v_ICSubsItem where 1=1" + sql);
            render :json =>{:data =>@fnumber}
        else
            return nopower!
        end
	end
end