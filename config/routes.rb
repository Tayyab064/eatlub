Rails.application.routes.draw do
  #resources :food_items
  #resources :restaurants
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  %w( 404 422 500 503 ).each do |code|
    get code, :to => "errors#show", :code => code
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'ajax' => 'website#ajax'
  get 'notification_test' => 'api#test_noti'

  root 'website#index'
  post 'signin' => 'website#signin' , as: 'website_signin'
  post 'signup' => 'website#signup' , as: 'website_signup'
  get 'postalcode' => 'website#search_postal' , as: 'postalcode_search_web'
  get 'nearby_restaurants' => 'website#restaurants_nearby' , as: 'restaurants_nearby'
  get 'deliverable_:name' => 'website#nearby_deliverables' , as: 'nearby_deliverables'
  get 'restaurant_:id' => 'website#restaurant' , as: 'restaurant_page'
  get 'deliver_:id' => 'website#get_deliverable' , as: 'deliverable_page'
  get 'menu_:id' => 'website#restaurant_menu' , as: 'restaurant_menu_page'
  get 'items_:id' => 'website#get_deliverable_item' , as: 'get_deliverable_item'
  get 'submit_restaurant' => 'website#submit_restaurant'
  post 'submit_restaurant' => 'website#save_restaurant' , as: 'save_restaurant'
  get 'submit_rider' => 'website#submit_driver'
  post 'submit_rider' => 'website#save_driver' , as: 'save_rider'
  get 'cart' => 'website#cart' , as: 'cart'
  get 'confirm' => 'website#confirm_order' , as: 'confirm_order'
  post 'save_order' => 'website#save_order' , as: 'web_save_order'
  get 'restaurants' => 'website#restaurant_listing' , as: 'web_restaurant_listing'
  get 'restaurants_grid' => 'website#restaurant_grid' , as: 'web_restaurant_grid'
  get 'orders' => 'website#orders' , as: 'web_user_orders'
  get 'order_O:id' => 'website#order' , as: 'web_user_order'
  get 'cancel_order_O:id' => 'website#cancel_order', as: 'web_user_cancel_order'
  get 'thankyou' => 'website#thankyou' , as: 'thankyou'
  post 'forget_password' => 'website#forget_password' , as: 'forget_password_website'
  get 'password_:token' => 'website#set_password' , as: 'set_password'
  put 'forgot_password' => 'website#save_password' , as: 'save_password_web'
  post 'review' => 'website#leaveareview' , as: 'leave_a_review'

  scope 'dashboard' do
    get 'signin' => 'dashboard#signin' , as: 'dashboard_signin'
    post 'signin_admin' => 'dashboard#approve_signin' , as: 'signin_admin'
    delete 'signout' => 'dashboard#signout' , as: 'admin_signout'

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
    put 'commission_:id' => 'dashboard#set_commission' , as: 'dashboard_commission'

    get 'unblock_restaurant_:id' => 'dashboard#unblock_restaurant' , as: 'dashboard_unblock_restaurant'
    get 'block_restaurant_:id' => 'dashboard#block_restaurant' , as: 'dashboard_block_restaurant'

    get 'rider_order_:id' => 'dashboard#rider_orders' , as: 'dashboard_rider_orders'

    get 'wallet' => 'dashboard#wallet' , as: 'user_wallets'
    post 'wallet' => 'dashboard#give_credit' , as: 'user_wallet_update'

    get 'promocode' => 'dashboard#promocode' , as: 'dashboard_promocode'
    post 'promocode' => 'dashboard#save_promocode'

    get 'deliverable_categories' => 'dashboard#deliverable_cat' , as: 'dashboard_deliverable_cat'
    post 'deliverable_categories' => 'dashboard#save_deliverable' , as: 'dashboard_deliverable_cat_save'

    get 'deliverable' => 'dashboard#deliverable' ,as: 'dashboard_deliverables'
    get 'approve_deliverable_:id' => 'dashboard#approve_deliverables' , as: 'approve_deliverable'
    get 'deliverable_mark_popular_:id' => 'dashboard#deliverable_mark_popular' , as: 'deliverable_mark_popular'
    get 'unblock_deliverable_:id' => 'dashboard#unblock_deliverable' , as: 'unblock_deliverable'
    get 'block_deliverable_:id' => 'dashboard#block_deliverable' , as: 'block_deliverable'
    put 'set_commission_deliverable_:id' => 'dashboard#set_commission_deliverable' , as: 'set_commission_deliverable'
  end

  scope 'owner' do
    get 'signin' => 'owner#signin' , as: 'owner_signin'
    post 'signin_admin' => 'owner#approve_signin' , as: 'signin_owner'
    delete 'signout' => 'owner#signout' , as: 'owner_signout'

    get 'index' => 'owner#index' , as: 'owner_index'
    get 'restaurants' => 'owner#restaurants' , as: 'owner_restaurants'
    get 'deliverables' => 'owner#deliverables' ,as: 'owner_deliverables'
    get 'fooditem_:id' => 'owner#restaurant_menu_add' , as: 'owner_restaurant_food_add'
    get 'restaurant_:id' => 'owner#restaurant_menu' , as: 'owner_restaurant_menu'
    post 'save_food_item' => 'owner#save_fooditem' , as: 'owner_save_fooditem'
    get 'orders' => 'owner#orders' , as: 'owner_orders'
    get 'deliverable_orders' => 'owner#deliverable_orders' , as: 'owner_deliverable_orders'
    get 'order_:id' => 'owner#order' , as: 'owner_order'
    get 'accept_:id' => 'owner#order_accept' , as: 'owner_order_accept'
    get 'dispatch_:id' => 'owner#order_dispatch' , as: 'owner_order_dispatch'
    get 'food_publish_:id' => 'owner#food_mark_visible' , as: 'fooditem_publish'
    get 'edit_fooditem_:id' => 'owner#edit_food' , as: 'edit_fooditem_owner'
    put 'fooditem_:id' => 'owner#update_food' , as: 'owner_restaurant_food_edit'
    post 'password' => 'owner#set_password' , as: 'owner_password'
    put 'order_:id' => 'owner#order_status' , as: 'owner_restaurant_order_status'
    get 'deliverable_:id' => 'owner#deliverable_menu' , as: 'owner_deliverable_menu'
    put 'deliver_order_:id' => 'owner#order_status_delivera'
    get 'deliver_item_:id' => 'owner#deliverable_menu_add' , as: 'owner_deliverable_menu_add'
    post 'save_deliver_item' => 'owner#save_deliver_item' , as: 'owner_save_deliver_item'
  end

  scope 'api' do

    scope 'user' do
      post 'signup' => 'api#signup_user' , as: 'api_signup_user'
      post 'signin' => 'api#signin_user' , as: 'api_signin_user'
      post 'forget_password' => 'api#forget_password'
      get 'nearby_restaurants' => 'api#nearby_restaurants' , as: 'api_nearby_restaurants'
      get 'nearby_:deliverable' => 'api#nearby_deliverable' , as: 'api_nearby_deliverable'

      scope 'restaurant' do
        get 'menu/:id' => 'api#restaurant_menu' , as: 'api_restaurant_menu'
      end

      scope 'deliverable' do
        get 'menu/:id' => 'api#deliverable_menu' , as: 'api_deliverable_menu'
      end

      post 'order' => 'api#create_order'
      get 'order' => 'api#get_orders'
      get 'myorder/:id' => 'api#get_specific_order'

      post 'tip/:id' => 'api#tip'

      get 'categories' => 'api#get_categories'

    end

    scope 'rider' do
      post 'signup' => 'api#signup_rider' , as: 'api_signup_rider'
      post 'signin' => 'api#signin_rider' , as: 'api_signin_rider'
      post 'forget_password' => 'api#forget_password'
      get 'online' => 'api#online'

      scope 'order' do
        get 'accept/:id' => 'api#rider_accept'
        get 'finish/:id' => 'api#finish_order'
        get 'complete/:id' => 'api#pay_bill'
        get 'arrived/restaurant/:id' => 'api#arrived_rest_order'
        get 'arrived/user/:id' => 'api#arrived_user_order'
      end
    end
    
  end
end
