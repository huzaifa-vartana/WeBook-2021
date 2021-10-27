Rails.application.routes.draw do
  devise_for :users
  resources :friendships, only: [:create, :destroy]
  resources :users, only: [:show]
  # resources :posts
  resources :posts do
    resources :comments, module: :posts
  end
  resources :comments do
    resources :comments, module: :comments
  end

  root to: "posts#index"
  get "my_friends", to: "users#my_friends"
  get "my_posts", to: "users#my_posts"
  # get "search_user", to: "users#my_friends"
  resources :posts, only: [:destroy]
  post "like_post/:post_id", to: "posts#like", as: "like_post"
  post "like_comment/:comment_id", to: "comments#like", as: "like_comment"
end
