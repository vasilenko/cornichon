Rails.application.routes.draw do
  resources :urls, controller: :links, param: :slug, only: %i[create show] do
    get :stats, on: :member
  end
end
