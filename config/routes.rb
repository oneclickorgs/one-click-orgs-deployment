OneClickOrgs::Application.routes.draw do
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  match '/amendments' => 'one_click#amendments', :as => 'amendments'
  match '/constitution' => 'one_click#constitution', :as => 'constitution'

  match '/timeline' => 'one_click#timeline', :as => 'timeline'

  match '/votes/vote_for/:id' => 'votes#vote_for', :conditions => {:method => :post}, :as => 'vote_for'
  match '/votes/vote_against/:id' => 'votes#vote_against', :conditions => {:method => :post}, :as => 'vote_against'

  resources :decisions
  resources :proposals do
    resources :comments
  end
  # TODO Don't want this global matching if possible:
  match '/proposals(/:action)' => 'proposals'


  resources :members do
    member do
      post :change_class
      put :confirm_resign
      put :resign
    end
    
    collection do
      post :create_founding_member
      get :resigned
    end
  end

  match '/one_click(/:action)' => 'one_click'
  #match '/induction(/:action)' => 'induction'

  match '/login' => 'member_sessions#new', :as => 'login'
  match '/logout' => 'member_sessions#destroy', :as => 'logout', :via => "get"
  resource :member_session, :only => [:new, :create, :destroy]

  match '/welcome(/:action)' => 'welcome'

  match '/setup(/:action)' => 'setup'

  resources :organisations
#  match '/organisations(/:action)' => 'organisations'

  match '/i/:id' => 'invitations#edit', :as => 'short_invitation'
  resources :invitations

  match '/r/:id' => 'password_resets#edit', :as => 'short_password_reset'
  resources :password_resets

  match '/admin/test_email' => 'admin#test_email', :conditions => { :method => :post }
  match '/admin/test_exception_notification' => 'admin#test_exception_notification'
  
  root :to => 'one_click#dashboard'
end
