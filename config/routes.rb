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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  resource :constitution
  resource :constitution_proposal_bundles

  get '/timeline' => 'one_click#timeline', :as => 'timeline'

  post '/votes/vote_for/:id' => 'votes#vote_for', :as => 'vote_for'
  post '/votes/vote_against/:id' => 'votes#vote_against', :as => 'vote_against'

  resources :decisions

  resources :proposals do
    member do
      put :open
    end

    resources :comments
  end
  # TODO Don't want this global matching if possible:
  match '/proposals(/:action)' => 'proposals'

  resources :add_member_proposals
  resources :eject_member_proposals
  resources :change_member_class_proposals
  resources :found_association_proposals

  resources :resolution_proposals do
    member do
      put :pass
      put :pass_to_meeting
    end

    resources :comments
  end

  resources :resolutions do
    resources :comments
  end
  resources :board_resolutions

  resources :change_meeting_notice_period_resolutions
  resources :change_quorum_resolutions

  resources :members do
    member do
      put :confirm_resign
      put :resign
      put :induct
    end

    collection do
      get :created
      get :resigned
    end
  end

  resources :founding_members

  resources :founder_members

  resources :directors do
    member do
      post :stand_down
    end
  end

  resources :directorships

  resources :officerships

  resources :elections do
    resources :ballots
  end

  match '/one_click(/:action)' => 'one_click'

  get '/login' => 'member_sessions#new', :as => 'login'
  get '/logout' => 'member_sessions#destroy', :as => 'logout'
  resource :member_session, :only => [:new, :create, :destroy]

  get '/admin/login' => 'administrator_sessions#new', :as => 'admin_login'
  get '/admin/logout' => 'administrator_sessions#destroy', :as => 'admin_logout'
  resource :administrator_session, :only => [:new, :create, :destroy]

  match '/welcome(/:action)' => 'welcome'

  match '/setup(/:action)' => 'setup'

  resources :organisations
  resources :associations
  resources :companies
  resources :coops do
    member do
      put :propose
    end
  end

  resources :meetings do
    resources :comments
  end
  resources :general_meetings
  resources :board_meetings

  resources :shares

  get '/admin' => 'admin#index'

  namespace :admin do
    resources :coops do
      member do
        put :found
      end
    end
  end

  get '/i/:id' => 'invitations#edit', :as => 'short_invitation'
  resources :invitations

  get '/r/:id' => 'password_resets#edit', :as => 'short_password_reset'
  resources :password_resets

  post '/system/test_email' => 'system#test_email'
  match '/system/test_exception_notification' => 'system#test_exception_notification'

  root :to => 'one_click#dashboard'
end
