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

  post 'receive/search' => 'receive#search'
  post 'receive/hydw' => 'receive#hydw'
  post 'receive/plgx' => 'receive#plgx'

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
  post 'fnumber/upload' => 'fnumber#upload'

  get 'custperfchar/load' => 'custperfchar#load'
  post 'custperfchar/upload' => 'custperfchar#upload'

  get 'fbillnoclosed/load' => 'fbillnoclosed#load'
  post 'fbillnoclosed/save' => 'fbillnoclosed#save'

  get 'seoutstock/load' => 'seoutstock#index'
  post 'seoutstock/getCk' => 'seoutstock#getCk'

  post 'deliveryorder/index' => 'deliveryorder#test_excel'
  post 'deliveryorder/ckdhChange' => 'deliveryorder#ckdhChange'
  

  post 'cancel/index' => 'cancelgoods#index'
  post 'cancel/fbillno' => 'cancelgoods#fbillno'
  post 'cancel/new' => 'cancelgoods#new'
  post 'cancel/del' => 'cancelgoods#del'
  post 'cancel/stockbill' => 'cancelgoods#stockbill'

  post 'tabbox/fbillno' => 'tabbox#fbillno'
  post 'tabbox/hh' => 'tabbox#hh'
  post 'tabbox/save' => 'tabbox#save'
  get 'tabbox/index' => 'tabbox#index'

  post 'asnlabel/upload' => 'asnlabel#upload'

  post 'icsearch' => 'icsearch#search'
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
