Rails.application.routes.draw do
  get 'fmc/index'
  get 'status/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  match "/" => "positions#index", via: [:get, :post]
  get 'positions/:id', to: "positions#show"
  post 'positions/find_by_alg'

  resources :alg_sets
  get 'alg_sets/compute/:ids', to: "alg_sets#compute"

  get 'hemlig', to: 'status#index'
  get 'fmc', to: 'fmc#index'

  get "wca_callback" => "oauth#wca"
  get "wca_logout" => "oauth#wca_logout"
  get "fake_wca_login" => "oauth#fake_wca_login"

end
