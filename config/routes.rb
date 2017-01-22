Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get 'fmc/index'
  get 'status/index'

  resources :galaxies , only: [:index, :show]
  get 'galaxies/remove_star'
  post 'galaxies/update_star'

  match "/" => "positions#index", via: [:get, :post]
  get 'positions/:id', to: "positions#show"
  post 'positions/find_by_alg'

  resources :alg_sets
  get 'alg_sets/compute/:ids', to: "alg_sets#compute"
  get 'alg_sets/:id/algs', to: "alg_sets#algs"

  get 'hemlig', to: 'status#index'
  get 'fmc', to: 'fmc#index'

  get "wca_callback" => "oauth#wca"
  get "wca_logout" => "oauth#wca_logout"
  get "fake_wca_login" => "oauth#fake_wca_login"

end
