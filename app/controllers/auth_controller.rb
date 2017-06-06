class AuthController < ApplicationController
	def K3
		@k3 = T_K3_Auth.all
		render :json =>{:data => @k3}
	end

	def icmo
		@icmo = T_Icmo_Auth.all
		render :json =>{:data => @icmo}
	end

	def receive
		@receive = T_Receive_Auth.all
		render :json =>{:data => @receive}
	end 

	def reject
		@reject = T_Reject_Auth.all
		render :json =>{:data => @reject}
	end

	def addk3
		@k3 = T_K3_Auth.new
	end
end