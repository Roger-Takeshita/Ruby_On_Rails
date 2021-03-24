Rails.application.routes.draw do

  namespace :admin do
    get 'dashboard/main'
    get 'dashboard/user'
    get 'dashboard/blog'
  end
  # get 'pages/about'
  get 'about', to: 'pages#about'

  # get 'pages/contact'
  get 'my_custom/route/contact/page', to: 'pages#contact', as: 'short_contact'
  resources :blogs
  resources :posts

  root to: 'pages#home'
end
