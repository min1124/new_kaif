class ReplaceController < ApplicationController
    before_action :authentication
	def index
        name = params[:name];
        if "程燕"==name || "test"==name
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