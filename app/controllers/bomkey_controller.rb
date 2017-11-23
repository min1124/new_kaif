class BomkeyController < ApplicationController
	before_action :authentication
	def load
		if power(T_K3_Auth, "t_bomkey_auth")
            @a = Bom_Key_Fnumbers.where(close_flag: "Y")
			render :json =>{:data =>@a}
		else
			return nopower!
		end
	end

	def fnumberY
        fnumberY = params[:fnumberY]
        #@a = ActiveRecord::Base.connection.select_all("exec BOMQuery "+ "'"+fnumberY+"'")
        @a = Key_Fnumbers.find_by_sql("exec KeyBomFnumbers "+ "'"+fnumberY+"'")
        
        fnumberHw = params[:fnumberHw]
        keyFnumber = params[:keyFnumber]
        #@b = ActiveRecord::Base.connection.select_all("exec BOMQuery "+ "'"+fnumberHw+"'")
        @b = Bom_Key_Fnumbers.find_by_sql("exec KeyBomFnumbersChildWeight "+ "'"+fnumberHw+"','"+keyFnumber+"'")        
        render :json =>{:data1 =>@a,:data2 =>@b}
    end

    def updSave
		if power(T_K3_Auth, "t_bomkey_auth")
        	id = params[:id];

			keyFnumberSel = params[:keyFnumberSel];
			fatherWeight = params[:fatherWeight];
			childWeitht = params[:childWeitht];

        	bomKeyFnumbers = Bom_Key_Fnumbers.find(id)
            bomKeyFnumbers.key_fnumber_sel = keyFnumberSel
            bomKeyFnumbers.father_weight = fatherWeight
            bomKeyFnumbers.child_weitht = childWeitht
        	bomKeyFnumbers.save

        	customerNumber = params[:customerNumber];
            fnumberHw = params[:fnumberHw];
          	keyFnumber = params[:keyFnumber];
          	@bom_key_fnumbers = Bom_Key_Fnumbers.where(customer_number:customerNumber,
          		close_flag:"Y",fnumber_hw:fnumberHw,key_fnumber:keyFnumber)
          	for i in 0..@bom_key_fnumbers.length-1
                @bom_key_fnumbers[i].child_weitht = childWeitht
                @bom_key_fnumbers[i].save
            end
            render :text => 0;
        else
        	return nopower!;
        end
	end
end