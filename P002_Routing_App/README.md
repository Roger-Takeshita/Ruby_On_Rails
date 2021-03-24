<h1 id='contents'>TABLE OF CONTENTS</h1>

- [ROUTING SYSTEM](#routing-system)
  - [Create New App](#create-new-app)
  - [Create Base Scaffold Functionality](#create-base-scaffold-functionality)
  - [Create Database and Migration](#create-database-and-migration)
  - [Routes](#routes)
  - [Controllers](#controllers)
    - [Custom Routes](#custom-routes)
    - [Routes Prefixes](#routes-prefixes)
    - [Referencing Prefix](#referencing-prefix)
  - [Root Route](#root-route)
    - [Pages Controller](#pages-controller)
    - [Home Page](#home-page)
  - [Nested Routes](#nested-routes)
    - [Routes](#routes-1)
      - [Dashboard Controller](#dashboard-controller)
      - [Dashboard Views](#dashboard-views)
    - [Routes From Scratch](#routes-from-scratch)
      - [Posts Controller](#posts-controller)
      - [Posts Views](#posts-views)
    - [Globbing](#globbing)
      - [Posts Routes](#posts-routes)
      - [Posts Controller](#posts-controller-1)
      - [Posts Missing Page](#posts-missing-page)
    - [Dynamic Routes](#dynamic-routes)
      - [Pages Routes](#pages-routes)
      - [Pages Controller](#pages-controller-1)
      - [Pages Something Page](#pages-something-page)

# ROUTING SYSTEM

## Create New App

[Go Back to Contents](#contents)

Create a new app using `PostgreSQL` as default database

```Bash
  rails new P002_Routing_App -T --database=postgresql
```

## Create Base Scaffold Functionality

[Go Back to Contents](#contents)

Let's create a basic `Blog` functionality using **scaffold generator**

With Scaffold generator, Rails will create all the necessary files such as `controllers`, `views` (index, show, edit, \_form), and `stylesheets`

- add the following fields

  - `title` type `string`
  - `body` type `text`

    ```Bash
      rails g scaffold Blog title:string body:text
      # Running via Spring preloader in process 1071
      # invoke  active_record
      # create    db/migrate/20210108033311_create_blogs.rb
      # create    app/models/blog.rb
      # invoke  resource_route
      #  route    resources :blogs
      # invoke  scaffold_controller
      # create    app/controllers/blogs_controller.rb
      # invoke    erb
      # create      app/views/blogs
      # create      app/views/blogs/index.html.erb
      # create      app/views/blogs/edit.html.erb
      # create      app/views/blogs/show.html.erb
      # create      app/views/blogs/new.html.erb
      # create      app/views/blogs/_form.html.erb
      # invoke    resource_route
      # invoke    helper
      # create      app/helpers/blogs_helper.rb
      # invoke    jbuilder
      # create      app/views/blogs/index.json.jbuilder
      # create      app/views/blogs/show.json.jbuilder
      # create      app/views/blogs/_blog.json.jbuilder
      # invoke  assets
      # invoke    scss
      # create      app/assets/stylesheets/blogs.scss
      # invoke  scss
      # create    app/assets/stylesheets/scaffolds.scss
    ```

## Create Database and Migration

[Go Back to Contents](#contents)

```Bash
  rake db:create
  # Created database 'P002_Routing_App_development'
  # Created database 'P002_Routing_App_test'

  rails db:migrate
  # == 20210108033311 CreateBlogs: migrating ======================================
  # -- create_table(:blogs)
  #    -> 0.0249s
  # == 20210108033311 CreateBlogs: migrated (0.0249s) =============================
```

## Routes

[Go Back to Contents](#contents)

Check the available routes

```Bash
  rake routes

  # Prefix Verb   URI Pattern                                                                                       Controller#Action
  #                                    blogs GET    /blogs(.:format)                                                                                  blogs#index
  #                                          POST   /blogs(.:format)                                                                                  blogs#create
  #                                 new_blog GET    /blogs/new(.:format)                                                                              blogs#new
  #                                edit_blog GET    /blogs/:id/edit(.:format)                                                                         blogs#edit
  #                                     blog GET    /blogs/:id(.:format)                                                                              blogs#show
  #                                          PATCH  /blogs/:id(.:format)                                                                              blogs#update
  #                                          PUT    /blogs/:id(.:format)                                                                              blogs#update
  #                                          DELETE /blogs/:id(.:format)                                                                              blogs#destroy
  #            rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
  #               rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
  #            rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
  #      rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
  #            rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
  #             rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
  #           rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
  #                                          POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
  #        new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
  #       edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                                 rails/conductor/action_mailbox/inbound_emails#edit
  #            rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
  #                                          PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
  #                                          PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
  #                                          DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#destroy
  # new_rails_conductor_inbound_email_source GET    /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
  #    rails_conductor_inbound_email_sources POST   /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
  #    rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
  #                       rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
  #                 rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
  #                                          GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
  #                rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
  #          rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
  #                                          GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
  #                       rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
  #                update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
  #                     rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
```

In `config/routes.rb`

```Ruby
  Rails.application.routes.draw do
    resources :blogs
  end

```

The `resources` will generate all the CRUD routes

```Bash
  rails routes | grep blog

  #     blogs GET    /blogs(.:format)            blogs#index
  #           POST   /blogs(.:format)            blogs#create
  #  new_blog GET    /blogs/new(.:format)        blogs#new
  # edit_blog GET    /blogs/:id/edit(.:format)   blogs#edit
  #      blog GET    /blogs/:id(.:format)        blogs#show
  #           PATCH  /blogs/:id(.:format)        blogs#update
  #           PUT    /blogs/:id(.:format)        blogs#update
  #           DELETE /blogs/:id(.:format)        blogs#destroy
```

![](https://i.imgur.com/wkoZVOp.png)

## Controllers

[Go Back to Contents](#contents)

We can user the generator to create the `Pages` controller and all the following pages: `about` and `contact`

```Bash
  rails g controller Pages about contact

  # Running via Spring preloader in process 3850
  #       create  app/controllers/pages_controller.rb
  #        route  get 'pages/about'
  # get 'pages/contact'
  #       invoke  erb
  #       create    app/views/pages
  #       create    app/views/pages/about.html.erb
  #       create    app/views/pages/contact.html.erb
  #       invoke  helper
  #       create    app/helpers/pages_helper.rb
  #       invoke  assets
  #       invoke    scss
  #       create      app/assets/stylesheets/pages.scss
```

After running the generator, this will add new routes in our `routes.rb`
In `config/routes.rb`

```Ruby
  Rails.application.routes.draw do
    get 'pages/about'
    get 'pages/contact'
    resources :blogs
  end
```

```Bash
  rails routes | grep page

  # pages_about   GET    /pages/about(.:format)     pages#about
  # pages_contact GET    /pages/contact(.:format)   pages#contact
```

### Custom Routes

[Go Back to Contents](#contents)

By default the generator will create the following routes

```Ruby
  get 'pages/about'
  get 'pages/contact'
  # http://localhost:3000/pages/about
  # http://localhost:3000/pages/contact
```

We can define custom routes to easily map these static pages

```Ruby
  Rails.application.routes.draw do
    # get 'pages/about'
    get 'about', to: 'pages#about'
    #      ^            ^     ^
    #      |            |     |
    #      |            |     └── action
    #      |            |
    #      |            └── controller
    #      |
    #      └── route

    # get 'pages/contact'
    get 'contact', to: 'pages#contact'
    #      ^              ^      ^
    #      |              |      |
    #      |              |      └── action
    #      |              |
    #      |              └── controller
    #      |
    #      └── route

    resources :blogs
  end
```

```Bash
  rails routes | grep page

  #about GET      /about(.:format)     pages#about
  #contact GET    /contact(.:format)   pages#contact
```

### Routes Prefixes

[Go Back to Contents](#contents)

If we create a custom crazy route like this:

```Ruby
  Rails.application.routes.draw do
    # get 'pages/about'
    get 'about', to: 'pages#about'

    # get 'pages/contact'
    get 'my_custom/route/contact/page', to: 'pages#contact'
    resources :blogs
  end
```

```Bash
  rails routes | grep page

  #                        about GET    /about(.:format)                         pages#about
  # my_custom_route_contact_page GET    /my_custom/route/contact/page(.:format)  pages#contact
```

### Referencing Prefix

[Go Back to Contents](#contents)

With our prefix we can reference in our `erb` file
If we want to create a link tag to point to the `contact` page
In `app/views/pages/about.html.erb`

```HTML
  <h1>Pages#about</h1>
  <p>Find me in app/views/pages/about.html.erb</p>

  <%=  link_to "Contact Page", my_custom_route_contact_page_path %>
```

We can customize the prefix so we can easily reference in our code
In `config/routes.rb`

```Ruby
  Rails.application.routes.draw do
    # get 'pages/about'
    get 'about', to: 'pages#about'

    # get 'pages/contact'
    get 'my_custom/route/contact/page', to: 'pages#contact', as: 'short_contact'
    resources :blogs
  end
```

In `app/views/pages/about.html.erb`

```HTML
  <h1>Pages#about</h1>
  <p>Find me in app/views/pages/about.html.erb</p>

  <%=  link_to "Contact Page", short_contact_path %>
```

```Bash
  rails routes | grep page

  #         about GET    /about(.:format)                         pages#about
  # short_contact GET    /my_custom/route/contact/page(.:format)  pages#contact
```

## Root Route

[Go Back to Contents](#table-of-contents)

In `config/routes.rb`

- Let's define our root route

  ```Ruby
    Rails.application.routes.draw do
      # get 'pages/about'
      get 'about', to: 'pages#about'

      # get 'pages/contact'
      get 'my_custom/route/contact/page', to: 'pages#contact', as: 'short_contact'
      resources :blogs

      root to: 'pages#home'
    end
  ```

### Pages Controller

[Go Back to Contents](#table-of-contents)

We can define our `home` action, we don't need to add anything in it, Rails is smart enough to render the new `home.html.erb`

```Ruby
  def home
  end
```

### Home Page

[Go Back to Contents](#table-of-contents)

Create new file

```Bash
  app/views/pages/home.html.erb
```

In `app/views/pages/home.html.erb`

```HTML
  <h1>Home Page</h1>
```

## Nested Routes

[Go Back to Contents](#table-of-contents)

Let's generate a nested route

```Bash
  rails g controller Dashboard main user blog
  create  app/controllers/dashboard_controller.rb
  #        route  get 'dashboard/main'
  # get 'dashboard/user'
  # get 'dashboard/blog'
  #       invoke  erb
  #       create    app/views/dashboard
  #       create    app/views/dashboard/main.html.erb
  #       create    app/views/dashboard/user.html.erb
  #       create    app/views/dashboard/blog.html.erb
  #       invoke  helper
  #       create    app/helpers/dashboard_helper.rb
  #       invoke  assets
  #       invoke    scss
  #       create      app/assets/stylesheets/dashboard.scss
```

> The `main`, `user`, and `blog` are just pages

### Routes

[Go Back to Contents](#table-of-contents)

In `config/routes.rb`

- After generating the routes, rails will add the new routes in our `routes.rb`

  ```Ruby
    Rails.application.routes.draw do
      get 'dashboard/main'
      get 'dashboard/user'
      get 'dashboard/blog'
      # get 'pages/about'
      get 'about', to: 'pages#about'

      # get 'pages/contact'
      get 'my_custom/route/contact/page', to: 'pages#contact', as: 'short_contact'
      resources :blogs

      root to: 'pages#home'
    end
  ```

- We can nest our routes using **namespace**

  ```Ruby
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

      root to: 'pages#home'
    end
  ```

#### Dashboard Controller

[Go Back to Contents](#table-of-contents)

When we create a **namespace** rails will try to look into folder inside our controllers called `admin` and inside admin folder a file named `dashboard_controller.rb`

```Bash
  mkdir app/controllers/admin
```

Move the `app/controllers/dashboard_controller.rb` file to `app/controllers/admin`

```Bash
  mv app/controllers/dashboard_controller.rb app/controllers/admin
```

In `app/controllers/admin/dashboard_controller.rb`

- To make it work our nesting routes, we need to update the class

  ```Ruby
    class Admin::DashboardController < ApplicationController
      def main
      end

      def user
      end

      def blog
      end
    end
  ```

  > To nest a route we need to add the class name in front of the Controller eg. `class Admin::DashboardController`

#### Dashboard Views

[Go Back to Contents](#table-of-contents)

We need to do the same thing with or nested views

```Bash
  mkdir app/views/admin
  mv app/views/dashboard app/views/admin
```

### Routes From Scratch

[Go Back to Contents](#table-of-contents)

In `config/routes.rb`

- We can create a new `resources`

  - The resource will generate all our routes to the `posts` controller

  ```Ruby
    resources :posts
  ```

  ![](https://i.imgur.com/dEmdqeD.png)

#### Posts Controller

[Go Back to Contents](#table-of-contents)

```Bash
  touch app/controllers/posts_controller.rb
```

```Ruby
  class PostsController < ApplicationController
    def index
    end
  end
```

#### Posts Views

[Go Back to Contents](#table-of-contents)

```Bash
  touch app/views/posts/index.html.erb
```

```HTML
  <h1>Here are the posts</h1>
```

### Globbing

#### Posts Routes

[Go Back to Contents](#table-of-contents)

In `config/routes.rb`

- Add a `globbing` (`route/*...`)

  ```Ruby
    get 'posts/*missing', to: 'posts#missing'
  ```

#### Posts Controller

[Go Back to Contents](#table-of-contents)

In `app/controllers/posts_controller.rb`

- Create a new action called `missing`

  ```Ruby
    def missing
    end
  ```

#### Posts Missing Page

[Go Back to Contents](#table-of-contents)

```Bash
  touch app/views/posts/missing.html.erb
```

```HTML
  <h1>These are not the posts that you were looking for</h1>
```

### Dynamic Routes

[Go Back to Contents](#table-of-contents)

Because we are using friendly routes, we can create an action to query our friendly routes using pieces of the route

#### Pages Routes

[Go Back to Contents](#table-of-contents)

In `config/routes.rb`

- Add a new route `query` that will map to `something` action

  ```Ruby
    get 'query/:else/:another_one', to: 'pages#something'
    get 'query/:else', to: 'pages#something'
  ```

#### Pages Controller

[Go Back to Contents](#table-of-contents)

In `app/controllers/pages_controller.rb`

- We can now get the `:else` params

  ```Ruby
    def something
      @else = params[:else]
      @another_one = params[:another_one]
    end
  ```

#### Pages Something Page

[Go Back to Contents](#table-of-contents)

```Bash
  touch app/views/pages/something.html.erb
```

```HTML
  <h1><%= @else %></h1>
  <h1><%= @another_one %></h1>

```
