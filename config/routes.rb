Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get 'fmc/index'
  get 'status/index'

  get 'galaxies/remove_star'
  post 'galaxies/update_star'
  resources :galaxies , only: [:index, :show]

  match "/" => "positions#index", via: [:get, :post]
  get 'positions/:id', to: "positions#show"
  post 'positions/find_by_alg'

  get 'alg_sets/update_cookie/', to: "alg_sets#update_cookie"
  resources :alg_sets
  get 'alg_sets/compute/:ids', to: "alg_sets#compute"
  get 'alg_sets/:id/algs', to: "alg_sets#algs", as: "mirrored_list"

  get 'hemlig', to: 'status#index'
  get 'fmc', to: 'fmc#index'

  get "wca_callback" => "oauth#wca"
  get "wca_logout" => "oauth#wca_logout"
  get "fake_wca_login" => "oauth#fake_wca_login"

end
