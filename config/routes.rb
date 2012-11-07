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
      get :support
      put :pass
      put :pass_to_meeting
    end

    resources :comments
  end

  resources :resolutions do
    resources :comments
  end
  resources :generic_resolutions
  resources :change_meeting_notice_period_resolutions
  resources :change_quorum_resolutions
  resources :change_name_resolutions
  resources :change_registered_office_address_resolutions
  resources :change_objectives_resolutions
  resources :change_membership_criteria_resolutions
  resources :change_board_composition_resolutions
  resources :change_single_shareholding_resolutions
  resources :change_common_ownership_resolutions

  resources :board_resolutions

  resources :members do
    member do
      get :confirm_eject
      put :eject

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

  resources :directorships do
    new do
      get :external
    end
  end

  resources :officerships
  resources :offices

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
  resources :annual_general_meetings
  resources :board_meetings
  resources :minutes

  resources :shares do
    collection do
      get :edit_share_value
      put :update_share_value

      get :edit_minimum_shareholding
      put :update_minimum_shareholding

      get :edit_interest_rate
      put :update_interest_rate
    end
  end
  resources :share_transactions do
    member do
      get :confirm_approve
      put :approve
    end
  end
  resources :share_applications
  resources :share_withdrawals

  resource :membership_application_form

  resource :registration_form

  resource :board

  resources :tasks do
    member do
      put :dismiss
    end
  end

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

  get '/checklist' => 'one_click#checklist', :as => 'checklist'
  root :to => 'one_click#dashboard'
end
