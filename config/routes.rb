Sonet::Application.routes.draw do
  #mount Ckeditor::Engine => '/ckeditor'
  resources :articles

	resources :users
	resources :user_sessions
	resources :static_pages
	resources :fronts
	resources :user_urls
	resources :url_contents
	resources :categories
	resources :contents
	
	get 'logout' => 'user_sessions#destroy', :as => :logout
	get 'login' => 'user_sessions#new', :as => :login
	get 'dashboard' => 'fronts#dashboard', :as => :dashboard
	
	get '/p/:username' => 'fronts#dashboard'
	
	get 'signin' => 'fronts#login', :as => :user_login
	

	match '/change_password' => 'fronts#change_password', :as => :change_password, via: [:get, :post, :patch]
  get '/fronts/other/:page_id' => 'fronts#other', :as => :other
  match '/forgot_password' => 'fronts#forgot_password', :as => :forgot_password, via: [:get, :post]
  
  get '/news/:id' => 'fronts#news', :as => :news
  
  get '/auth/twitter/callback', :to => 'fronts#auth_login'
  get '/auth/facebook/callback', :to => 'fronts#auth_login'
  get '/auth/google_oauth2/callback', :to => 'fronts#auth_login'
  
  get '/oauth2callback', :to => 'fronts#auth_login'
  get '/auth/failure', :to => 'fronts#dashboard'
  get '/:fp' => 'fronts#other'
  match '/facebook/add_post_id' => 'url_contents#add_post_id', :as => :add_post_id, via: [:get]
  
  match '/user_url/share_content' => 'user_urls#share_content', :as => :share_content, via: [:get, :post, :patch]
  match '/user_url/send_content' => 'user_urls#send_content', :as => :send_content, via: [:get, :post, :patch]
  
  match '/sonet/share_content' => 'fronts#share_content', :as => :sonet_share_content, via: [:get, :post, :patch]
  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'fronts#dashboard'

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
