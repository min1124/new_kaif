class T_K3_Auth < ActiveRecord::Base
	self.table_name = "t_k3_auth"
	establish_connection :typo

	def null
		self.t_bom_auth = ""
		self.t_hj_auth = ""
		self.t_icmo_auth = ""
		self.t_reject_auth = ""
		self.t_recieve_auth = ""
		self.t_order_auth = ""
		self.t_change_auth = ""
		self.t_delivery_auth = ""
		self.t_return_auth = ""
		self.t_cancel_auth = ""
		self.t_stockbill_auth = ""
		self.t_icsearch_auth = ""
		self.t_fnumber_auth = ""
		self.t_perfchar_auth = ""
		self.t_seoutstock_auth = ""
		self.t_delayorder_auth = ""
		self.t_bfprice_auth = ""
		self.t_bomkey_auth = ""
		self.t_custperfchar_auth = ""
		self.t_fnumberhw_auth = ""
		self.t_fnumberdesc_auth = ""
		self.t_keyfnumbers_auth = ""
		self.t_replace_auth = ""
		self.t_zxhub_auth = ""
		self.t_rejectyf_auth = ""
		self.t_rejectkc_auth = ""
		self.save
	end
end