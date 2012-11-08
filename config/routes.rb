Queuep::Application.routes.draw do
  resources :replies, only: [:show]

  match '/signup',       to: 'users#create'
  match '/logoff',       to: 'users#destroy'
  match '/users/show',   to: 'users#show'
  match '/users/update', to: 'users#update'

  match '/login',      to: 'sessions#create'
  match '/logout',     to: 'sessions#destroy'

  match '/groups/create',            to: 'groups#create'
  match '/groups/show',              to: 'groups#show'
  match '/groups/count',             to: 'groups#count'
  match '/groups/delete',            to: 'groups#destroy'
  match '/groups/is_admin',          to: 'groups#is_admin'
  match '/groups/is_creator',        to: 'groups#is_creator'
  match '/groups/is_member',         to: 'groups#is_member'
  match '/groups/transfer_admin',    to: 'groups#transfer_admin'
  match '/groups/update',            to: 'groups#update'
  match '/groups/join',              to: 'memberships#create'
  match '/groups/leave',             to: 'memberships#destroy'
  match '/groups/authorize_member',  to: 'memberships#authorize_member'
  match '/groups/unauthorize_member',to: 'memberships#unauthorize_member'

  match '/posts/create',             to: 'posts#create'
  match '/posts/delete',             to: 'posts#destroy'
  match '/posts/edit',               to: 'posts#update'
  match '/posts/is_author',          to: 'posts#is_author'
  match '/posts/user_posts',         to: 'posts#user_posts'
  match '/posts/group_posts',        to: 'posts#group_posts'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
