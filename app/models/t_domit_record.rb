class TDomitRecord < ActiveRecord::Base
	def checkout
		update(checkinfo: 0)
	end
end
