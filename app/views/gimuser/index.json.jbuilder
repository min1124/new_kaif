

json.user @gimuser, :id, :work_no, :password

json.a do	
  	json.id "@gimuser.id"
	json.work_no "@gimuser.work_no"
	json.password "@gimuser.password_digest"    
end