Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'positions#index'

  get 'base_algs/index'

  get 'demo/index'

  resources :positions
  resources :algs

  resources :base_algs do
    collection do
      post :combine
      post :update_positions
    end
  end
end
