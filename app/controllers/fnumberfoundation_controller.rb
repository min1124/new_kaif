class FnumberfoundationController < ApplicationController
	before_action :authentication
	def load
		if power(T_K3_Auth, "t_bomkey_auth")
            @a = Cust_Fnumber.find_by_sql("select * from V_FnumberFoundation")
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end
end