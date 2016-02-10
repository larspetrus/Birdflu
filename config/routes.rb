Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  match "/" => "positions#index", via: [:get, :post]

  get 'positions/:id', to: "positions#show"

  post 'positions/find_by_alg'

  get "wca_callback" => "oauth#wca"
  get "wca_logout" => "oauth#wca_logout"

end
