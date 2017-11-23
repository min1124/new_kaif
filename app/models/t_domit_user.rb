class TDomitUser < ActiveRecord::Base
    validates_uniqueness_of  :work_no,conditions:->{where(state: 1)} ,:message =>"工号已存在" 
	validates_uniqueness_of  :id_no,conditions:->{where(state: 1)} , :message =>"身份证已存在" 
	validates_presence_of  :email,  :message =>"邮箱不能为空!"   
	# belongs_to :t_department,foreign_key: "dept_no"
end
