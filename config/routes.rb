Rails.application.routes.draw do
  #resources :food_items
  #resources :restaurants
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  %w( 404 422 500 503 ).each do |code|
    get code, :to => "errors#show", :code => code
  end

  root 'website#index'
  post 'nearby_restaurants' => 'website#restaurants_nearby' , as: 'restaurants_nearby'
  get 'restaurant_:id' => 'website#restaurant' , as: 'restaurant_page'
  get 'menu_:id' => 'website#restaurant_menu' , as: 'restaurant_menu_page'
  get 'submit_restaurant' => 'website#submit_restaurant'
  post 'submit_restaurant' => 'website#save_restaurant' , as: 'save_restaurant'
  get 'submit_rider' => 'website#submit_driver'
  post 'submit_rider' => 'website#save_driver' , as: 'save_rider'

  scope 'dashboard' do
  	get 'index' => 'dashboard#index' , as: 'dashboard_index'
  	get 'restaurants' => 'dashboard#restaurants' , as: 'dashboard_restaurants'
  	get 'end_users' => 'dashboard#end_user' , as: 'dashboard_end_users'
  	get 'restaurant_owner' => 'dashboard#restaurant_owner' , as: 'dashboard_restaurant_owner'
  	get 'rider' => 'dashboard#rider' , as: 'dashboard_rider'
  	get 'admin' => 'dashboard#admin' , as: 'dashboard_admin'
  	put 'set_password' => 'dashboard#set_password_user' , as: 'dashboard_set_password'
  	get 'unblock_user' => 'dashboard#unblock_user' , as: 'dashboard_unblock_user'
    get 'restaurant_approve_:id' => 'dashboard#rest_mark_approved' , as: 'restaurant_mark_approve'
  end

  scope 'owner' do
    get 'index' => 'owner#index' , as: 'owner_index'
    get 'restaurants' => 'owner#restaurants' , as: 'owner_restaurants'
  end
end
