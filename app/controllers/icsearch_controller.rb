class IcsearchController < ApplicationController
	def search
		# if power(T_K3_Auth, "t_bom_auth")
			fnumber = params[:fnumber]
			fname = params[:fname]
			fmodel = params[:fmodel]
			if fnumber == ''
				fnumber_sql = ''
			else
				fnumber_sql = "fnumber like '%"+fnumber+"%'"
			end
			if fname == ''
				fname_sql = ''
			else
				if fnumber_sql == ''
					fname_sql = "fname like '%"+fname+"%'"
				else
					fname_sql = "and fname like '%"+fname+"%'"
				end
			end
			if fmodel == ''
				fmodel_sql = ''
			else
				if fname_sql == ''
					fmodel_sql = "fmodel like '%"+fmodel+"%'"
				else
					fmodel_sql = "and fmodel like '%"+fmodel+"%'"
				end
			end
			@a = Icitem.find_by_sql('select fnumber,SUBSTRING(FModel,0,255) as fmodel,fname from t_icitem where '+fnumber_sql+fmodel_sql+fname_sql)
			render :json =>{:data => @a}
		# else
  #           return nopower!
  #       end
	end
end