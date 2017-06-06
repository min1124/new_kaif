class ApplicationController < ActionController::API
	# def api_error(opts = {})
 #    	render nothing: true, status: opts[:status]
 #    end

	def unauthenticated!
		render nothing: true, status: 401
	end
	
	def nopower!
		render nothing: true, status: 402
	end

	def  wrongtype!
		render nothing: true, status: 403
	end

	def authentication #登录验证
	    #return unauthenticated! unless current_user
	    token = params[:token] 
	    name=params[:name]
	    user = name && TUser.find_by(name: name)
	    if user && secure_compare(user.authentication_token, token)
	
	    else
	      return unauthenticated! #未登录
	    end
  	end 

	def power(a, b)#权限验证
		@user = TUser.find_by(name: params[:name]) 
		if @user.power_flag !='1'
			puts @user.power_flag
	  		@a=a.where("name = ? and "+b+"= ?", params[:name],1)
			if @a[0] 
				return a
			else
				
			end
		else
		end
    end  	

    def secure_compare(a, b)
	    return false if a.blank? || b.blank? || a.bytesize != b.bytesize
	    l = a.unpack "C#{a.bytesize}"

        res = 0
	    b.each_byte { |byte| res |= byte ^ l.shift }
	    res == 0
  	end

 
    def auth(table,sql)
    	name = params[:name]
    	@user = table.find_by_name(name)
    	if @user
			@user.null  
			@table = @user  			
    	else
    		@table = table.new()
    		@table.name = name
    	end

	    @a=sql.split(" ")    	
    	for i in 0..@a.length-1
    		b = @a[i]
    		@table[b] = 1 
    	end
    	@table.save
	    
    end
end
