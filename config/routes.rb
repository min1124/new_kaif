Rails.application.routes.draw do
  get 'bom/index' => 'bom#index'
  post 'bom/bomp' => 'bom#BOMP'
  post 'bom/bomc' => 'bom#BOMC'
  post 'bom/hj' => 'bom#hj'
  # post 'bom/hjsearch' => 'bom#hjsearch'
  post 'icmo/index' => 'icmo#index'
  post 'icmo/ppbom_entry' => 'icmo#PPBom_Entry'
  post 'icmo/ppbom_main' => 'icmo#PPBom_Main'
  post 'icmo/review' => 'icmo#review'
  post 'icmo/sub' => 'icmo#sub'


  get 'reject/index' => 'reject#index'
  post 'reject/zzd' => 'reject#zzd'
  post 'reject/rejection' => 'reject#Rejection'
  post 'reject/t_RejectionEntry' => 'reject#t_RejectionEntry'
  post 'reject/t_Rejection' => 'reject#t_Rejection'
  post 'reject/dept' => 'reject#dept'
  post 'reject/de' => 'reject#de'
  post 'reject/sh' => 'reject#sh'
  post 'reject/delete' => 'reject#delete'
  post 'reject/gb' => 'reject#gb'
  post 'reject/plsh' => 'reject#plsh'
  post 'reject/sgPlshQx' => 'reject#sgPlshQx' 
  post 'reject/sgPlsh' => 'reject#sgPlsh'
  post 'reject/cwPlshQx' => 'reject#cwPlshQx' 
  post 'reject/cwPlsh' => 'reject#cwPlsh' 
  post 'reject/fgfzPlshQx' => 'reject#fgfzPlshQx'
  post 'reject/plshSjJy' => 'reject#plshSjJy'

  get 'rejectyf/index' => 'rejectyf#index'
  post 'rejectyf/zzd' => 'rejectyf#zzd'
  post 'rejectyf/rejection' => 'rejectyf#Rejection'
  post 'rejectyf/t_RejectionEntry' => 'rejectyf#t_RejectionEntry'
  post 'rejectyf/t_Rejection' => 'rejectyf#t_Rejection'
  post 'rejectyf/dept' => 'rejectyf#dept'
  post 'rejectyf/de' => 'rejectyf#de'
  post 'rejectyf/sh' => 'rejectyf#sh'
  post 'rejectyf/delete' => 'rejectyf#delete'
  post 'rejectyf/gb' => 'rejectyf#gb'
  post 'rejectyf/plsh' => 'rejectyf#plsh'
  post 'rejectyf/sgPlshQx' => 'rejectyf#sgPlshQx' 
  post 'rejectyf/sgPlsh' => 'rejectyf#sgPlsh'
  post 'rejectyf/cwPlshQx' => 'rejectyf#cwPlshQx' 
  post 'rejectyf/cwPlsh' => 'rejectyf#cwPlsh' 
  post 'rejectyf/fgfzPlshQx' => 'rejectyf#fgfzPlshQx'
  post 'rejectyf/plshSjJy' => 'rejectyf#plshSjJy'

  get 'rejectkc/index' => 'rejectkc#index'
  post 'rejectkc/cpdm' => 'rejectkc#cpdm'
  post 'rejectkc/rejection' => 'rejectkc#Rejection'
  post 'rejectkc/t_RejectionEntry' => 'rejectkc#t_RejectionEntry'
  post 'rejectkc/t_Rejection' => 'rejectkc#t_Rejection'
  post 'rejectkc/dept' => 'rejectkc#dept'
  post 'rejectkc/de' => 'rejectkc#de'
  post 'rejectkc/ck' => 'rejectkc#ck'
  post 'rejectkc/sh' => 'rejectkc#sh'
  post 'rejectkc/delete' => 'rejectkc#delete'
  post 'rejectkc/gb' => 'rejectkc#gb'
  post 'rejectkc/plsh' => 'rejectkc#plsh'
  post 'rejectkc/sgPlshQx' => 'rejectkc#sgPlshQx' 
  post 'rejectkc/sgPlsh' => 'rejectkc#sgPlsh'
  post 'rejectkc/cwPlshQx' => 'rejectkc#cwPlshQx' 
  post 'rejectkc/cwPlsh' => 'rejectkc#cwPlsh' 
  post 'rejectkc/fgfzPlshQx' => 'rejectkc#fgfzPlshQx'
  post 'rejectkc/plshSjJy' => 'rejectkc#plshSjJy'

  post 'receive/search' => 'receive#search'
  post 'receive/hydw' => 'receive#hydw'
  post 'receive/plgx' => 'receive#plgx'

  get 'retrieve/index' => 'retrieve#index'
  post 'retrieve/zzd' => 'retrieve#zzd'
  post 'retrieve/cpdm' => 'retrieve#cpdm'
  post 'retrieve/rejection' => 'retrieve#Rejection'
  post 'retrieve/t_RejectionEntry' => 'retrieve#t_RejectionEntry'
  post 'retrieve/t_Rejection' => 'retrieve#t_Rejection'
  post 'retrieve/dept' => 'retrieve#dept'
  post 'retrieve/de' => 'retrieve#de'
  post 'retrieve/sh' => 'retrieve#sh'
  post 'retrieve/delete' => 'retrieve#delete'
  post 'retrieve/sgPlshQx' => 'retrieve#sgPlshQx' 
  post 'retrieve/sgPlsh' => 'retrieve#sgPlsh'
  post 'retrieve/plshSjJy' => 'retrieve#plshSjJy'

  post 'order/index' => 'order#index'
  post 'order/upload' => 'order#upload'
  post 'order/edit' => 'order#edit'
  post 'order/edit_1' => 'order#edit_1'
  post 'order/fnumber' => 'order#fnumber'
  post 'order/create' => 'order#create'
  post 'order/create_1' => 'order#create_1'
  post 'order/ghdw' => 'order#ghdw'
  post 'order/ywy' => 'order#ywy'
  get 'order/ghdw_all' => 'order#ghdw_all'
  post 'order/new' => 'order#new'
  post 'order/close' => 'order#close'
  post 'order/open' => 'order#open'

  get 'zxhub/load' => 'zxhub#load'
  post 'zxhub/delete' => 'zxhub#delete'
  post 'zxhub/save' => 'zxhub#save'

  get 'bfprice/load' => 'bfprice#load'
  post 'bfprice/upload' => 'bfprice#upload'

  post 'auth/k3' => 'auth#K3'
  post 'auth/icmo' => 'auth#icmo'
  post 'auth/receive' => 'auth#receive'
  post 'auth/reject' => 'auth#reject'

  post 'user/index' => 'user#index'
  post 'user/edit' => 'user#edit'
  post 'user/power' => 'user#update_power'
  post 'user/power2' => 'user#update_power2'
  post 'user/user' => 'user#update_user'
  post 'user/pswupdate' => 'user#pswupdate'

  post 'return/upload' => 'return#upload'
  post 'return/index' => 'return#index'
  post 'return/info' => 'return#info'
  post 'return/time' => 'return#time'
  post 'return/excel' => 'return#excel'

  post 'delivery/index' => 'delivery#index'
  post 'delivery/hs_2' => 'delivery#hs_2'

  get 'delivery/test' => 'delivery#test'

  post 'change/index' => 'change#index'
  post 'change/header' => 'change#header'
  post 'change/body' => 'change#body'
  post 'change/review' => 'change#review'
  post 'change/show' => 'change#show'
  post 'change/header1' => 'change#header1'
  post 'change/body1' => 'change#body1'
  post 'change/review1' => 'change#review1'

  post 'plm' => 'user#plm'

  post 'arrival/upload' => 'arrivalrate#upload'
  post 'arrival/index' => 'arrivalrate#index'
  post 'arrival/info' => 'arrivalrate#info'
  post 'arrival/getid' => 'arrivalrate#getid'
  post 'arrival/delete' => 'arrivalrate#delete'

  post 'fnumberzy/index' => 'fnumberzy#index'
  post 'fnumberzy/createCheck' => 'fnumberzy#createCheck'
  post 'fnumberzy/save' => 'fnumberzy#save'
  post 'fnumberzy/upd' => 'fnumberzy#upd'
  post 'fnumberzy/updSave' => 'fnumberzy#updSave'
  post 'fnumberzy/del' => 'fnumberzy#del'
  post 'fnumberzy/getfnumber' => 'fnumberzy#getfnumber'
  post 'fnumberzy/checkFnumber' => 'fnumberzy#checkFnumber'
  post 'fnumberzy/fnumber' => 'fnumberzy#fnumber'
  post 'fnumberzy/customerCode' => 'fnumberzy#customerCode'
  post 'fnumberzy/productLine' => 'fnumberzy#productLine'
  post 'fnumberzy/updQuery' => 'fnumberzy#updQuery'
  post 'fnumberzy/upload' => 'fnumberzy#upload'

  post 'fnumber/index' => 'fnumber#index'
  post 'fnumber/save' => 'fnumber#save'
  post 'fnumber/upd' => 'fnumber#upd'
  post 'fnumber/updSave' => 'fnumber#updSave'
  post 'fnumber/del' => 'fnumber#del'
  post 'fnumber/f102' => 'fnumber#f102'
  post 'fnumber/getfnumber' => 'fnumber#getfnumber'
  post 'fnumber/checkFnumber' => 'fnumber#checkFnumber'
  post 'fnumber/fnumber' => 'fnumber#fnumber'
  post 'fnumber/customerCode' => 'fnumber#customerCode'
  post 'fnumber/productLine' => 'fnumber#productLine'
  post 'fnumber/updQuery' => 'fnumber#updQuery'
  post 'fnumber/fnumberselect' => 'fnumber#fnumberselect'
  post 'fnumber/fnumberselchange' => 'fnumber#fnumberselchange'
  post 'fnumber/fnumberdesc' => 'fnumber#fnumberdesc'
  post 'fnumber/keyfnumber' => 'fnumber#keyfnumber'
  post 'fnumber/upload' => 'fnumber#upload'

  get 'custperfchar/load' => 'custperfchar#load'
  post 'custperfchar/upload' => 'custperfchar#upload'

  get 'keyfnumbers/load' => 'keyfnumbers#load'
  post 'keyfnumbers/upload' => 'keyfnumbers#upload'

  get 'fnumberdesc/load' => 'fnumberdesc#load'
  post 'fnumberdesc/upload' => 'fnumberdesc#upload'

  post 'fnumberfoundation/load' => 'fnumberfoundation#load'
  
  post 'bomkey/load' => 'bomkey#load'
  post 'bomkey/fnumberY' => 'bomkey#fnumberY'
  post 'bomkey/updSave' => 'bomkey#updSave'

  post 'fnumberbomkey/load' => 'fnumberbomkey#load'

  get 'fbillnoclosed/load' => 'fbillnoclosed#load'
  post 'fbillnoclosed/save' => 'fbillnoclosed#save'

  get 'seoutstock/load' => 'seoutstock#index'
  post 'seoutstock/getCk' => 'seoutstock#getCk'

  post 'deliveryorder/index' => 'deliveryorder#test_excel'
  post 'deliveryorder/ckdhChange' => 'deliveryorder#ckdhChange'

  post 'replace/index' => 'replace#index'
  
  post 'cancel/index' => 'cancelgoods#index'
  post 'cancel/fbillno' => 'cancelgoods#fbillno'
  post 'cancel/new' => 'cancelgoods#new'
  post 'cancel/del' => 'cancelgoods#del'
  post 'cancel/stockbill' => 'cancelgoods#stockbill'

  post 'tabbox/fbillno' => 'tabbox#fbillno'
  post 'tabbox/hh' => 'tabbox#hh'
  post 'tabbox/save' => 'tabbox#save'
  get 'tabbox/index' => 'tabbox#index'

  post 'delayorder/examplePC' => 'delayorder#examplePC'
  post 'delayorder/exampleDO' => 'delayorder#exampleDO'
  post 'delayorder/getCpTypePY' => 'delayorder#getCpTypePY'
  post 'delayorder/examplePY' => 'delayorder#examplePY'
  post 'delayorder/examplePCD' => 'delayorder#examplePCD'
  post 'delayorder/examplePD' => 'delayorder#examplePD'
  post 'delayorder/exampleDOD' => 'delayorder#exampleDOD'
  post 'delayorder/exampleDOC' => 'delayorder#exampleDOC'
  post 'delayorder/pcExcel' => 'delayorder#pcExcel'
  post 'delayorder/doExcel' => 'delayorder#doExcel'
  post 'delayorder/pyExcel' => 'delayorder#pyExcel'
  post 'delayorder/pcdExcel' => 'delayorder#pcdExcel'
  post 'delayorder/pdExcel' => 'delayorder#pdExcel'
  post 'delayorder/dodExcel' => 'delayorder#dodExcel'
  post 'delayorder/docExcel' => 'delayorder#docExcel'

  post 'delayorderfnumber/load' => 'delayorderfnumber#load'
  post 'delayorderfnumber/save' => 'delayorderfnumber#save'
  post 'delayorderfnumber/updsave' => 'delayorderfnumber#updsave'

  post 'delayordericmo/load' => 'delayordericmo#load'
  post 'delayordericmo/save' => 'delayordericmo#save'
  post 'delayordericmo/updsave' => 'delayordericmo#updsave'

  post 'asnlabel/upload' => 'asnlabel#upload'

  post 'icsearch' => 'icsearch#search'

  get 'users/index' => 'users#index'
  get 'users/new' => 'users#usernew'
  post '/users/new' => 'users#create'
  get 'users/edit/' => 'users#edit'
  delete 'users/delete/:id' => 'users#delete'
  post 'users/update/' => 'users#update'
  post 'users/search' => 'users#search'
  get 'user/power' => 'users#power'

  #post '/users/new' => 'users#create'
  #get 'room/roomarr' => 'rooms#roomarr'
  get 'room/index' => 'rooms#index'
  post 'room/index' => 'rooms#create'
  get 'room/bed' => 'rooms#bed'
  delete 'room/delete/:id' => 'rooms#delete'
  get 'room/edit/' => 'rooms#edit'#, as: :roomedit
  post 'room/update/' => 'rooms#update'
  post 'room/search' => 'rooms#search'

  post 'domit/index' => 'domit#create'
  get 'domit/edit' => 'domit#edit'
  get 'domit/index' => 'domit#index'
  post 'domit/update/' => 'domit#update'
  delete 'domit/delete/' => 'domit#delete'

  post 'domit/checkin' => 'domitrecord#checkin'
  post 'domit/checkout/' => 'domitrecord#checkout'

  get 'gimuser/index' => 'gimuser#index'
  get 'gimuser/new' => 'gimuser#new'
  post 'gimuser/new' =>'gimuser#create'

  post '/login' => 'session#create'
  get 'login' => 'session#new'
  get '/logout' => 'session#destory'
  get '/session' => 'session#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
