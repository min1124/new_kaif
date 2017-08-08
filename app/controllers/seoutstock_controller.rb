class SeoutstockController < ApplicationController
    before_action :authentication
    def index
        if power(T_K3_Auth, "t_seoutstock_auth")
            #@a=Fbillno_Closed.find_by_sql("select * from v_SEOutStockNomalAndVmi where FCheckerID = 'Y' and FClosed = 'N' and fNumber not like '30.%'")
            @a=Fbillno_Closed.find_by_sql("select t1.*,t2.fqtySum from v_SEOutStockNomalAndVmi t1
                left join v_icinventory t2 on t1.fNumber = t2.FNumber
                where t1.FCheckerID = 'Y' and t1.FClosed = 'N' and t1.fNumber not like '30.%'
                and t2.ckNumber = '1.03'");
            render :json =>{:data =>@a}
        else
            return nopower!
        end
    end
	def getCk
    	@a=Fbillno_Closed.find_by_sql("select distinct ckNumber,ckName from v_icinventory order by ckNumber")
    	render :json =>{:ckData =>@a}
	end
end