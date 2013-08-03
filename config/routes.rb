Economy::Application.routes.draw do
  resources :articles

	resources :users
	resources :user_sessions
	resources :static_pages
	resources :fronts
	
	get 'logout' => 'user_sessions#destroy', :as => :logout
	get 'login' => 'user_sessions#new', :as => :login
	get 'dashboard' => 'fronts#dashboard', :as => :dashboard
	get 'feedbacks' => 'fronts#feedbacks', :as => :feedbacks
	get 'readlog' => 'fronts#readlog', :as => :readlog
	
	
	get '/p/:username' => 'fronts#dashboard'
	
	match '/feedback/:tracking_pixel' => 'fronts#feedback', :as => :feedback, via: [:get, :post, :patch]
	
	match 'invite' => 'fronts#invite', :as => :invite, via: [:get, :post, :patch]
	get '/is_email_invited' => 'fronts#is_email_invited', :as => :is_email_invited
	
	get 'subscribe' => 'fronts#subscribe', :as => :subscribe
	get 'signin' => 'fronts#login', :as => :user_login
	
	match '/leave/feedback' => 'fronts#leave_feedback', :as => :leave_feedback, via: [:get, :post, :patch]
	
	get 'cv.xml' => 'fronts#cv_xml', :as => :cv_xml
	
	match '/change_password' => 'fronts#change_password', :as => :change_password, via: [:get, :post, :patch]
  get '/fronts/other/:page_id' => 'fronts#other', :as => :other
  match '/forgot_password' => 'fronts#forgot_password', :as => :forgot_password, via: [:get, :post]
  get '/auth/linkedin/callback', :to => 'fronts#auth_linkedin_login'
  get '/auth/facebook/callback', :to => 'fronts#auth_facebook_login'
  get '/oauth2callback', :to => 'fronts#auth_login'
  get '/auth/failure', :to => 'fronts#dashboard'
  get '/:fp' => 'fronts#other'
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
