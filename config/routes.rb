Rails.application.routes.draw do

  root to: 'landing#index'
  get :about, to: 'static_pages#about'  #:about read faster than string
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :topics
end
