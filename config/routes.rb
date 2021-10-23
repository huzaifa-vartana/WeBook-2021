Rails.application.routes.draw do
  devise_for :users
  resources :friendships, only: [:create, :destroy]
  resources :users, only: [:show]
  resources :posts
  # resources :posts do
  #   resources :likes, only: [:create, :destroy]
  # end
  root to: "posts#index"
  get "my_friends", to: "users#my_friends"
  get "my_posts", to: "users#my_posts"
  get "search_user", to: "users#search"
  resources :posts, only: [:destroy]
  post "like_post/:post_id", to: "posts#like", as: "like_post"
end
