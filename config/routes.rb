Nambrotdotcom::Application.routes.draw do
  get "madagascar$", to: redirect("madagascar/")
  get "madagascar/" => "madagascar#index"
  get "madagascar/:anything" => "madagascar#index"
  # mount Blogit::Engine => "/", :as => :blog
  resources :posts
  root 'posts#index'
  get 'about' => 'high_voltage/pages#show', :id => 'about'
  get 'aroundtheworld' => 'high_voltage/pages#show', :id => 'aroundtheworld'
  get 'namsremote' => 'high_voltage/pages#show', :id => 'namsremote'
  get 'mapsoffline' => 'high_voltage/pages#show', :id => 'mapsoffline'
  get 'resume' => 'posts#resume'
  get 'hire' => 'high_voltage/pages#show', :id => 'hire'
  post 'forms/hire' => "forms#hire"
  post 'forms/fire' => "forms#fire"
  get 'blog' => "blogit/posts#index"
  get 'blog/:id' => 'blogit/posts#show'
  get 'multi_part_tweets' => 'multi_part_tweets#show'
  mount Ahoy::Engine => "/ahoy"
  match '*path', via: :all, to: 'application#error_404'
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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
