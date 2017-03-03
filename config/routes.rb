Rails.application.routes.draw do
  #resources :food_items
  #resources :restaurants
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  %w( 404 422 500 503 ).each do |code|
    get code, :to => "errors#show", :code => code
  end

  get 'ajax' => 'website#ajax'

  root 'website#index'
  post 'signin' => 'website#signin' , as: 'website_signin'
  post 'signup' => 'website#signup' , as: 'website_signup'
  post 'nearby_restaurants' => 'website#restaurants_nearby' , as: 'restaurants_nearby'
  get 'restaurant_:id' => 'website#restaurant' , as: 'restaurant_page'
  get 'menu_:id' => 'website#restaurant_menu' , as: 'restaurant_menu_page'
  get 'submit_restaurant' => 'website#submit_restaurant'
  post 'submit_restaurant' => 'website#save_restaurant' , as: 'save_restaurant'
  get 'submit_rider' => 'website#submit_driver'
  post 'submit_rider' => 'website#save_driver' , as: 'save_rider'
  get 'cart' => 'website#cart' , as: 'cart'
  get 'confirm' => 'website#confirm_order' , as: 'confirm_order'
  post 'save_order' => 'website#save_order' , as: 'web_save_order'
  get 'restaurants' => 'website#restaurant_listing' , as: 'web_restaurant_listing'
  get 'orders' => 'website#orders' , as: 'web_user_orders'
  get 'order_O:id' => 'website#order' , as: 'web_user_order'
  get 'cancel_order_O:id' => 'website#cancel_order', as: 'web_user_cancel_order'

  scope 'dashboard' do
    get 'signin' => 'dashboard#signin' , as: 'dashboard_signin'
    post 'signin_admin' => 'dashboard#approve_signin' , as: 'signin_admin'

  	get 'index' => 'dashboard#index' , as: 'dashboard_index'
  	get 'restaurants' => 'dashboard#restaurants' , as: 'dashboard_restaurants'
  	get 'end_users' => 'dashboard#end_user' , as: 'dashboard_end_users'
  	get 'restaurant_owner' => 'dashboard#restaurant_owner' , as: 'dashboard_restaurant_owner'
  	get 'rider' => 'dashboard#rider' , as: 'dashboard_rider'
  	get 'admin' => 'dashboard#admin' , as: 'dashboard_admin'
  	put 'set_password' => 'dashboard#set_password_user' , as: 'dashboard_set_password'
  	get 'unblock_user' => 'dashboard#unblock_user' , as: 'dashboard_unblock_user'
    get 'block_user' => 'dashboard#block_user' , as: 'dashboard_block_user'
    get 'restaurant_approve_:id' => 'dashboard#rest_mark_approved' , as: 'restaurant_mark_approve'
    get 'restaurant_popular_:id' => 'dashboard#rest_mark_popular' , as: 'restaurant_mark_popular'
  end

  scope 'owner' do
    get 'signin' => 'owner#signin' , as: 'owner_signin'
    post 'signin_admin' => 'owner#approve_signin' , as: 'signin_owner'

    get 'index' => 'owner#index' , as: 'owner_index'
    get 'restaurants' => 'owner#restaurants' , as: 'owner_restaurants'
    get 'fooditem_:id' => 'owner#restaurant_menu_add' , as: 'owner_restaurant_food_add'
    get 'restaurant_:id' => 'owner#restaurant_menu' , as: 'owner_restaurant_menu'
    post 'save_food_item' => 'owner#save_fooditem' , as: 'owner_save_fooditem'
    get 'orders' => 'owner#orders' , as: 'owner_orders'
    get 'order_:id' => 'owner#order' , as: 'owner_order'
    get 'accept_:id' => 'owner#order_accept' , as: 'owner_order_accept'
    get 'dispatch_:id' => 'owner#order_dispatch' , as: 'owner_order_dispatch'
  end
end
