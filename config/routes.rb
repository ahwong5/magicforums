Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  root to: 'landing#index'

  post :upvote, to: 'votes#upvote'
  post :cancelvote, to: 'votes#cancelvote'
  post :downvote, to: 'votes#downvote'

  get :about, to: 'static_pages#about'  #:about read faster than string
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :topics, except: [:show] do    #no longer need to show individual topic/post
    resources :posts, except: [:show] do
      resources :comments, except: [:show]
    end
  end

  resources :users, only: [:index, :new, :edit, :create, :update]

  resources :sessions, only: [:new, :create, :destroy]

  resources :password_resets, only: [:new, :edit, :create, :update]
end
