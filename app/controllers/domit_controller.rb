class DomitController < ApplicationController
	def index
		@domitlocates=TDomitLocate.all
		#render :json =>@domitlocates 
		render :json =>{:data => @domitlocates}
	end
	
	def new
		# case params[:action]
		# when "create"
		# 	@locate=TDomitLocate.new
		# 	if @locate.save
		# 	    render :json =>@locate
		# 	else
		# 	    render :text => "0"
		# 	end
		# when "edit"
		# 	update
		# when "delete"
		# 	render :text => 1
		# else
		# end

		# @locate.domit_no=params[:domit_no]
		# @locate.domit_name=params[:domit_name]
		# @locate.domit_adress=params[:domit_adress]
		# @a=params[:data][:"0"]	
		# if @locate.save
		#     render :text => "1"
		# else
		#     render :text => "0"
		# end
		# @locate=TDomitLocate.new(domit_params)
		render :json =>params.values#[:action]
	end

	def create
        @locate=TDomitLocate.new(domit_params)
        # @locate.domit_no=params[:domit_no]
        # @locate.domit_name=params[:domit_name]
        # @locate.domit_adress=params[:domit_adress]

        if @locate.save
            render :text => "1"
        else
            render :text => "0"
        end
	end

	def delete
		@locate=TDomitLocate.find(params[:id])
		if @locate.destroy
			render :text => "1"
		else
			render :text => "0"
		end
	end
	def edit
		@locate=TDomitLocate.find(params[:id])
		#render :json =>@locate 
		render :json =>{:data => @locate}
	end
	def update
		@locate=TDomitLocate.find(params[:data].values[:id])
		@locate.domit_no=params[:data].values[:domit_no]
		@locate.domit_name=params[:data].values[:domit_name]
		@locate.domit_adress=params[:data].values[:domit_adress]
		if @locate.update
			render :json => @locate
		else
			render :text => "0"
		end
	end

	private
	def domit_params
		params.permit(:domit_no,:domit_name,:domit_adress)
	end
end
