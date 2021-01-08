Rails.application.routes.draw do
  # get 'pages/about'
  get 'about', to: 'pages#about'

  # get 'pages/contact'
  get 'my_custom/route/contact/page', to: 'pages#contact', as: 'short_contact'
  resources :blogs
end
