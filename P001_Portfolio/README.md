<h1 id='contents'>Table of Contents</h1>

- [LINKS](#links)
- [PROJECT 001 - PORTFOLIO](#project-001---portfolio)
  - [Start New Project](#start-new-project)
    - [Start Server](#start-server)
    - [Scaffold](#scaffold)
    - [Routes](#routes)
    - [Clean Up](#clean-up)
    - [Controller Workflow](#controller-workflow)
    - [Controllers](#controllers)
      - [Controller Generator](#controller-generator)
    - [Model](#model)
      - [Model Generator](#model-generator)
      - [Rails Console](#rails-console)
    - [Resource](#resource)
      - [Resource Generator](#resource-generator)
    - [Customizations](#customizations)
      - [Customizing Generator](#customizing-generator)
      - [Customizing Templates](#customizing-templates)
    - [Dataflow](#dataflow)
      - [Seeds File](#seeds-file)
      - [Portfolio Controller](#portfolio-controller)
        - [SHOW PORTFOLIOS](#show-portfolios)
        - [NEW PORTFOLIO](#new-portfolio)
        - [EDIT PORTFOLIO](#edit-portfolio)
        - [PORTFOLIO ROUTES](#portfolio-routes)
        - [LINKS](#links-1)
        - [EDIT](#edit)
        - [SHOW](#show)
        - [DESTROY](#destroy)
      - [Routes](#routes-1)
        - [MAPPING ROUTES](#mapping-routes)

# LINKS

[Go Back to Contents](#contents)

- [Rails Scaffold Templates](https://github.com/rails/rails/tree/master/railties/lib/rails/generators/erb/scaffold/templates)
- [Faker](https://github.com/faker-ruby/faker)
- [Image Generator](https://placeholder.com/)

# PROJECT 001 - PORTFOLIO

## Start New Project

[Go Back to Contents](#contents)

- On `Terminal`

  ```Bash
    rails new P001_Portfolio -T --database=postgresql
    # rails new <name_of_your_project> -T --database=postgresql
    # the name cannot have spaces
    # -T removes the test files
  ```

### Start Server

[Go Back to Contents](#contents)

- On `Terminal`

  ```Bash
    cd P001_Portfolio
    bundle install
    rails db:create
    # Created database 'P001_Portfolio_development'
    # Created database 'P001_Portfolio_test'
    rails db:migrate
    rails s
    # => Booting Puma
    # => Rails 6.0.3.4 application starting in development
    # => Run `rails server --help` for more startup options
    # Puma starting in single mode...
    # * Version 4.3.6 (ruby 2.7.2-p137), codename: Mysterious Traveller
    # * Min threads: 5, max threads: 5
    # * Environment: development
    # * Listening on tcp://127.0.0.1:3000
    # * Listening on tcp://[::1]:3000
    # Use Ctrl-C to stop
  ```

### Scaffold

[Go Back to Contents](#contents)

- **Scaffold** is the ability to generate multiple files with a single line of code
- In this case we are going to generate a new **Blog** table

  ```Bash
    rails g scaffold Blog title:string body:text
    # g            = generator
    # scaffold     = the type of generator that we are using
    # Blog         = the name of the table (needs to capitalized)
    # title:string = title field, data type string
    # body:text    = body field, data type text

    # /Users/roger-that/.rvm/rubies/ruby-2.7.0/lib/ruby/2.7.0/x86_64-darwin19/stringio.bundle: warning: already initialized constant StringIO::VERSION
    # Running via Spring preloader in process 69183
    #       invoke  active_record
    #       create    db/migrate/20201124231705_create_blogs.rb
    #       create    app/models/blog.rb
    #       invoke  resource_route
    #        route    resources :blogs
    #       invoke  scaffold_controller
    #       create    app/controllers/blogs_controller.rb
    #       invoke    erb
    #       create      app/views/blogs
    #       create      app/views/blogs/index.html.erb
    #       create      app/views/blogs/edit.html.erb
    #       create      app/views/blogs/show.html.erb
    #       create      app/views/blogs/new.html.erb
    #       create      app/views/blogs/_form.html.erb
    #       invoke    helper
    #       create      app/helpers/blogs_helper.rb
    #       invoke    jbuilder
    #       create      app/views/blogs/index.json.jbuilder
    #       create      app/views/blogs/show.json.jbuilder
    #       create      app/views/blogs/_blog.json.jbuilder
    #       invoke  assets
    #       invoke    scss
    #       create      app/assets/stylesheets/blogs.scss
    #       invoke  scss
    #       create    app/assets/stylesheets/scaffolds.scss

    rails db:migrate
    # == 20201124231705 CreateBlogs: migrating ======================================
    # -- create_table(:blogs)
    #    -> 0.0328s
    # == 20201124231705 CreateBlogs: migrated (0.0329s) =============================
  ```

- in `db/migrate/20201124231705_create_blogs.rb`

  - We can check all the fields that we specified (`rails g scaffold Blog title:string body:text`)

    ```Ruby
      class CreateBlogs < ActiveRecord::Migration[6.0]
        def change
          create_table :blogs do |t|
            t.string :title
            t.text :body

            t.timestamps
          end
        end
      end
    ```

- Out of the box rails gives us all CRUD operation

  ![](https://i.imgur.com/FMR7L4P.png)

  ![](https://i.imgur.com/Px4Mpps.png)

  ![](https://i.imgur.com/LOhsgam.png)

  ![](https://i.imgur.com/34Hzrpn.png)

### Routes

[Go Back to Contents](#contents)

- To check the available routes we can use the Terminal
- On `Terminal`

  ```Bash
    rails routes
  ```

  ![](https://i.imgur.com/mK0qFCO.png)

- Or we can use the browser

  - [http://localhost:3000/rails/info/routes](http://localhost:3000/rails/info/routes)

  ![](https://i.imgur.com/xNcLX6H.png)

### Clean Up

[Go Back to Contents](#contents)

- Remove the following files, we are going to create our own later

  ```Bash
    rm app/assets/stylesheets/scaffolds.scss
  ```

### Controller Workflow

[Go Back to Contents](#contents)

- In `app/controllers/blogs_controller.rb`

  - we can see that we have `before_action :set_blog, only: [:show, :edit, :update, :destroy]`

    - this means that for the `show`, `edit`, `update`, and `destroy` **actions**, we are going to user **set_blog**

      - `only` for these actions
      - it's the same thing as:

        ```Ruby
          def show
            @blog = Blog.find(params[:id])
          end
        ```

      - in this case rails created a private method called **set_blog** and then `before_action` applies the custom method for each action

  - The `def new` action, only instantiate the **Blog Form**

    ```Ruby
      # GET /blogs/new
      def new
        @blog = Blog.new
      end
    ```

    - in `app/views/blogs/new.html.erb`

      - the **new action** will render the form

        ```HTML
          <h1>New Blog</h1>

          <%= render 'form', blog: @blog %>

          <%= link_to 'Back', blogs_path %>
        ```

      - in `app/views/blogs/_form.html.erb`

        ```HTML
          <%= form_with(model: blog, local: true) do |form| %>
            <% if blog.errors.any? %>
              <div id="error_explanation">
                <h2><%= pluralize(blog.errors.count, "error") %> prohibited this blog from being saved:</h2>

                <ul>
                  <% blog.errors.full_messages.each do |message| %>
                    <li><%= message %></li>
                  <% end %>
                </ul>
              </div>
            <% end %>

            <div class="field">
              <%= form.label :title %>
              <%= form.text_field :title %>
            </div>

            <div class="field">
              <%= form.label :body %>
              <%= form.text_area :body %>
            </div>

            <div class="actions">
              <%= form.submit %>
            </div>
          <% end %>
        ```

        - then once we submit the form, it will call the **create action**

  - The `def create` action is really what creates the new document

    - Because we are passing **@blog**, rails knows that it needs to redirect to the blog's main page
      - Another option we could use
        - `format.html { redirect_to blog_path(@blog), notice: 'Blog was successfully created.' }`

    ```Ruby
      def create
        @blog = Blog.new(blog_params)

        respond_to do |format|
          if @blog.save
            format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
          else
            format.html { render :new }
          end
        end
      end
    ```

  ```Ruby
    class BlogsController < ApplicationController
      before_action :set_blog, only: [:show, :edit, :update, :destroy]

      # GET /blogs
      # GET /blogs.json
      def index
        @blogs = Blog.all
      end

      # GET /blogs/1
      # GET /blogs/1.json
      def show
      end

      # GET /blogs/new
      def new
        @blog = Blog.new
      end

      # GET /blogs/1/edit
      def edit
      end

      # POST /blogs
      # POST /blogs.json
      def create
        @blog = Blog.new(blog_params)

        respond_to do |format|
          if @blog.save
            format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
          else
            format.html { render :new }
          end
        end
      end

      # PATCH/PUT /blogs/1
      # PATCH/PUT /blogs/1.json
      def update
        respond_to do |format|
          if @blog.update(blog_params)
            format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
          else
            format.html { render :edit }
          end
        end
      end

      # DELETE /blogs/1
      # DELETE /blogs/1.json
      def destroy
        @blog.destroy
        respond_to do |format|
          format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_blog
          @blog = Blog.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def blog_params
          params.require(:blog).permit(:title, :body)
        end
    end
  ```

### Controllers

[Go Back to Contents](#contents)

- The good practices when we are generating a new controller is to:
  - Capitalize the name
  - Plural verb

#### Controller Generator

[Go Back to Contents](#contents)

- On `Terminal`

  - We are going to generate `home`, `about`, and `contract` page

  ```Bash
    rails g controller Pages home about contact
    # Running via Spring preloader in process 28791
    #       create  app/controllers/pages_controller.rb
    #        route  get 'pages/home'
    # get 'pages/about'
    # get 'pages/contact'
    #       invoke  erb
    #       create    app/views/pages
    #       create    app/views/pages/home.html.erb
    #       create    app/views/pages/about.html.erb
    #       create    app/views/pages/contact.html.erb
    #       invoke  helper
    #       create    app/helpers/pages_helper.rb
    #       invoke  assets
    #       invoke    scss
    #       create      app/assets/stylesheets/pages.scss
  ```

- MVC (Model View Controller)
  - It gives a dataflow

### Model

[Go Back to Contents](#contents)

- The good practices when we are generating a new model is to:
  - Capitalize the name
  - Singular verb

#### Model Generator

[Go Back to Contents](#contents)

- On `Terminal`

  ```Bash
    rails g model Skill title:string percent_utilized:integer
    # Running via Spring preloader in process 38873
    # invoke  active_record
    # create    db/migrate/20201126224644_create_skills.rb
    # create    app/models/skill.rb
    rails db:migrate
    # == 20201126224644 CreateSkills: migrating =====================================
    # -- create_table(:skills)
    #    -> 0.0365s
    # == 20201126224644 CreateSkills: migrated (0.0365s) ============================
  ```

#### Rails Console

[Go Back to Contents](#contents)

- On `Terminal`

  - Lets create our dummy data using the rails console

  ```Bash
    rails c
    Skill.create!(title: "Rails", percent_utilized: 75)
    # Skill   = Table name
    # .create = method
    # !       = just in case we miss some field,
    #           rails will throw an error

    # (14.5ms)  BEGIN
    #  Skill Create (4.5ms)  INSERT INTO "skills" ("title", "percent_utilized", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["title", # "Rails"], ["percent_utilized", 75], ["created_at", "2020-11-26 22:53:06.398554"], ["updated_at", "2020-11-26 22:53:06.398554"]]
    #   (4.8ms)  COMMIT
    => #<Skill id: 1, title: "Rails", percent_utilized: 75, created_at: "2020-11-26 22:53:06", updated_at: "2020-11-26 22:53:06">

    Skill.create!(title: "HTML", percent_utilized: 5)
    Skill.create!(title: "Angular", percent_utilized: 10)

    Skill.all
    # Skill Load (0.2ms)  SELECT "skills".* FROM "skills" LIMIT $1  [["LIMIT", 11]]
    => #<ActiveRecord::Relation [#<Skill id: 1, title: "Rails", percent_utilized: 75, created_at: "2020-11-26 22:53:06", updated_at: "2020-11-26 22:53:06">, #<Skill id: 2, title: "HTML", percent_utilized: 5, created_at: "2020-11-26 22:55:56", updated_at: "2020-11-26 22:55:56">, #<Skill id: 3, title: "Angular", percent_utilized: 10, created_at: "2020-11-26 22:56:02", updated_at: "2020-11-26 22:56:02">]>
  ```

### Resource

[Go Back to Contents](#contents)

- The good practices when we are generating a new resource is to:
  - Capitalize the name
  - Singular verb
- The idea of **resources**, they are skinny **scaffold**, because the they generate:
  - Empty controllers (just the basic class)
  - Empty models (just the basic class)
  - Empty view
- The resource generator will add a new **resources** to our `routes.rb` with all CRUD operation available

#### Resource Generator

[Go Back to Contents](#contents)

- On `Terminal`

  ```Bash
    rails g resource Portfolio title:string subtitle:string body:text main_image:text thumb_image:text
    # Running via Spring preloader in process 41991
    # invoke  active_record
    # create    db/migrate/20201126231053_create_portfolios.rb
    # create    app/models/portfolio.rb
    # invoke  controller
    # create    app/controllers/portfolios_controller.rb
    # invoke    erb
    # create      app/views/portfolios
    # invoke    helper
    # create      app/helpers/portfolios_helper.rb
    # invoke    assets
    # invoke      scss
    # create        app/assets/stylesheets/portfolios.scss
    # invoke  resource_route
    #  route    resources :portfolios
    rails db:migrate
    # == 20201126231053 CreatePortfolios: migrating =================================
    # -- create_table(:portfolios)
    #    -> 0.0279s
    # == 20201126231053 CreatePortfolios: migrated (0.0280s) ========================
  ```

### Customizations

#### Customizing Generator

[Go Back to Contents](#contents)

- After generating a new app, we can delete our initial css

  ```Bash
    rm app/assets/stylesheets/scaffolds.scss
  ```

- In `config/application.rb`

  - This is our main application file system
  - Here we can add custom properties
  - For example we could change the **generators** configuration

    ```Ruby
      module P001Portfolio
        class Application < Rails::Application
          config.load_defaults 6.0

          config.generators do |g|
          g.orm             :active_record
          # use default standard communication to the database
          g.template_engine :erb
          # use erb as template engine (similar to jsx)
          g.test_framework  :test_unit, fixture: false
          # use test_unit as default tester
          g.stylesheets     false
          # don't generate stylesheets
          g.javascript      false
          # don't generate javascript

          config.generators.system_tests = nil
        end
      end
    ```

#### Customizing Templates

[Go Back to Contents](#contents)

- Create a new folder and files

  ```Bash
    touch lib/templates/erb/scaffold/index.html.erb
  ```

- We can use the rails original code to use as template to create our own version
- [Rails Scaffold Templates](https://github.com/rails/rails/tree/master/railties/lib/rails/generators/erb/scaffold/templates)

- In `lib/templates/erb/scaffold/index.html.erb`

  ```HTML
    <h2><%= plural_table_name.titleize %></h2>
    <p id="notice"><%%= notice %></p>
    <hr>
    <div>
      <%% @<%= plural_table_name %>.each do |<%= singular_table_name %>| %>
      <div>
        <% attributes.reject(&:password_digest?).each do |attribute| -%>
          <p><%%= <%= singular_table_name %>.<%= attribute.column_name %> %></p>
        <% end -%>
        <p><%%= link_to 'Show', <%= model_resource_name %> %></p>
        <p><%%= link_to 'Edit', edit_<%= singular_route_name %>_path(<%= singular_table_name %>) %></p>
        <p><%%= link_to 'Destroy', <%= model_resource_name %>, method: :delete, data: { confirm: 'Are you sure?' } %></p>
      </div>
      <%% end %>
    </div>
    <br>
    <%%= link_to 'New <%= singular_table_name.titleize %>', new_<%= singular_route_name %>_path %>
  ```

### Dataflow

#### Seeds File

[Go Back to Contents](#contents)

- We are going to install **Faker** library to seed our database with dummy data
- [https://github.com/faker-ruby/faker](https://github.com/faker-ruby/faker)

- In `db/seeds.rb`

  ```Ruby
    10.times do |blog|
      Blog.create!(
        title: "My Blog Post #{blog}",
        body: Faker::Lorem.paragraph_by_chars
      )
    end

    puts "10 blog posts created"

    5.times do |skill|
      Skill.create!(
        title: "Rails #{skill}",
        percent_utilized: rand(0..100)
      )
    end

    puts "5 skills created"

    9.times do |portfolio_item|
      Portfolio.create!(
        title: "Portfolio title: #{portfolio_item}",
        subtitle: Faker::Book.title,
        body: Faker::Lorem.paragraph_by_chars,
        main_image: "https://via.placeholder.com/600x400",
        thumb_image: "https://via.placeholder.com/350x200"
      )
    end

    puts "9 portfolio items created"
  ```

  - On `Terminal`

    ```Bash
      rails db:setup
      # Clean all data of our database (only for dev environment)

      # 10 blog posts created
      # 5 skills created
      # 9 portfolio items created
    ```

#### Portfolio Controller

---

##### SHOW PORTFOLIOS

[Go Back to Contents](#contents)

- In `app/controllers/portfolios_controller.rb`

  ```Ruby
    class PortfoliosController < ApplicationController
      def index
        @portfolio_items = Portfolio.all
      end

      def new
        @portfolio_item = Portfolio.new
      end
    end
  ```

- In `app/views/portfolios/index.html.erb`

  ```HTML
    <h1>Portfolio Items</h1>
    <% @portfolio_items.each do |item| %>
      <p><%= item.title %></p>
      <p><%= item.subtitle %></p>
      <p><%= item.body %></p>
      <p><%= image_tag item.thumb_image if !item.thumb_image.nil? %></p>
    <% end %>
  ```

---

##### NEW PORTFOLIO

[Go Back to Contents](#contents)

- In `app/controllers/portfolios_controller.rb`

  ```Ruby
    class PortfoliosController < ApplicationController
      def index
        @portfolio_items = Portfolio.all
      end

      def new
        @portfolio_item = Portfolio.new
      end

      def create
        @portfolio_item = Portfolio.create(params.require(:portfolio).permit(:title, :subtitle, :body))

        respond_to do |format|
          if @portfolio_item.save
            format.html { redirect_to portfolios_path, notice: "Your portfolio has been created" }
          else
            format.html { render :new }
          end
        end
      end
    end
  ```

- In `app/views/portfolios/new.html.erb`

  ```HTML
    <h1>Create a new Portfolio Item</h1>
    <%= form_for(@portfolio_item) do |form| %>
      <div class="field">
        <%= form.label :title %>
        <%= form.text_field :title %>
      </div>
      <div class="field">
        <%= form.label :subtitle %>
        <%= form.text_field :subtitle %>
      </div>
      <div class="field">
        <%= form.label :body %>
        <%= form.text_area :body %>
      </div>
      <div class="actions">
        <%= form.submit %>
      </div>
    <% end %>
  ```

---

##### EDIT PORTFOLIO

[Go Back to Contents](#contents)

- In `app/controllers/portfolios_controller.rb`

  ```Ruby
    class PortfoliosController < ApplicationController
      def index
        @portfolio_items = Portfolio.all
      end

      def new
        @portfolio_item = Portfolio.new
      end

      def create
        @portfolio_item = Portfolio.create(params.require(:portfolio).permit(:title, :subtitle, :body))

        respond_to do |format|
          if @portfolio_item.save
            format.html { redirect_to portfolios_path, notice: "Your portfolio has been created" }
          else
            format.html { render :new }
          end
        end
      end

      def edit
        @portfolio_item = Portfolio.find(params[:id])
      end

      def update
        @portfolio_item = Portfolio.find(params[:id])
        respond_to do |format|
          if @portfolio_item.update(params.require(:portfolio).permit(:title, :subtitle, :body))
            format.html { redirect_to portfolios_path, notice: "Your portfolio has updated" }
          end
        end
      end
    end
  ```

- In `app/views/portfolios/edit.html.erb`

  ```HTML
    <h1>Edit this Portfolio Item</h1>
    <%= form_for(@portfolio_item) do |form| %>
      <div class="field">
        <%= form.label :title %>
        <%= form.text_field :title %>
      </div>
      <div class="field">
        <%= form.label :subtitle %>
        <%= form.text_field :subtitle %>
      </div>
      <div class="field">
        <%= form.label :body %>
        <%= form.text_area :body %>
      </div>
      <div class="actions">
        <%= form.submit %>
      </div>
    <% end %>
  ```

---

##### PORTFOLIO ROUTES

[Go Back to Contents](#contents)

- On `Terminal`

  - We can check the available routes

    ```Bash
      rake routes | grep portfolio
    ```

    ![](https://i.imgur.com/Pkrl4PZ.png)

---

##### LINKS

[Go Back to Contents](#contents)

- We have 3 different ways to redirect a different page

  - Using a hard coded path

    ```HTML
      <a href="portfolios/new">Create New Item</a>
    ```

  - Using **path** (relative path)

    ```HTML
      <%= link_to "Create New Item", new_portfolio_path %>
      <!-- /portfolios/new -->
    ```

  - Using **url** (absolute path)

    ```HTML
      <%= link_to "Create New Item", new_portfolio_url %>
      <!-- http://localhost:3000/portfolios/new -->
    ```

  - finding the right **path**

    ![](https://i.imgur.com/ZCY7HyA.png)

---

##### EDIT

[Go Back to Contents](#contents)

- We can send the data though our `html.erb`

  ```HTML
    <%= link_to "Edit", edit_portfolio_path(item.id) %>
  ```

  - in this case we are using the `edit_portfolio_path` and sending the `item.id`, so rails understands that it needs to populate the fields

---

##### SHOW

[Go Back to Contents](#contents)

- Create the show page

  ```Bash
    touch app/views/portfolios/show.html.erb
  ```

- In `app/views/portfolios/show.html.erb`

  - We can inspect the `@portfolio_item` variable that we created and we are passing to our template

    ```HTML
      <%= @portfolio_item.inspect %>
    ```

    ```HTML
      <%= image_tag @portfolio_item.main_image %>

      <h1><%= @portfolio_item.title %></h1>

      <em><%= @portfolio_item.subtitle %></em>

      <p><%= @portfolio_item.body %></p>
    ```

- In `app/views/portfolios/index.html.erb`

  - Create a link to show individual portfolio, we can create an `<a>` tag using `link_to`
  - `item.title` will be the displayed in the `<a>` tag
  - Then we need to add a `,` (comma) followed by the path. Similar to `Edit` path, we can do the same to the show path. The only difference is that we don't need to specify anything in front of the path. `portfolio_path(item.id)`
    - Because rails knows that we are going to pass the `.id` to go to the show/edit page. We don't necessarily pass `item.id` we could pass just `item`

  ```HTML
    <p><%= link_to item.title, portfolio_path(item.id) %></p>
  ```

  ```HTML
    <h1>Portfolio Items</h1>
    <%= link_to "Create New Item", new_portfolio_path %>
    <p><%= new_portfolio_path %></p>
    <p><%= new_portfolio_url %></p>
    <% @portfolio_items.each do |item| %>
      <p><%= link_to item.title, portfolio_path(item) %></p>
      <p><%= item.subtitle %></p>
      <p><%= item.body %></p>
      <p><%= image_tag item.thumb_image if !item.thumb_image.nil? %></p>
      <%= link_to "Edit", edit_portfolio_path(item) %>
    <% end %>
  ```

---

##### DESTROY

[Go Back to Contents](#contents)

- Using the `rails c` console

  ```Bash
    rails c
    # Running via Spring preloader in process 49011
    # Loading development environment (Rails 6.0.3.4)

    portfolio = Portfolio.last
    # Portfolio Load (0.4ms)  SELECT "portfolios".* FROM "portfolios" ORDER BY "portfolios"."id" DESC LIMIT $1  [["LIMIT", 1]]

    portfolio
    # => #<Portfolio id: 9, title: "Portfolio title: 8", subtitle: "For a Breath I Tarry", body: "Tenetur eum vel. Quia et maxime. Reprehenderit adi...", main_image: "https://via.placeholder.com/600x400", thumb_image: "https://via.placeholder.com/350x200", created_at: "2020-11-30 20:08:02", updated_at: "2020-11-30 20:08:02">

    portfolio.delete
    # Portfolio Destroy (4.4ms)  DELETE FROM "portfolios" WHERE "portfolios"."id" = $1  [["id", 9]]
    # => #<Portfolio id: 9, title: "Portfolio title: 8", subtitle: "For a Breath I Tarry", body: "Tenetur eum vel. Quia et maxime. Reprehenderit adi...", main_image: "https://via.placeholder.com/600x400", thumb_image: "https://via.placeholder.com/350x200", created_at: "2020-11-30 20:08:02", updated_at: "2020-11-30 20:08:02">

    portfolio_two = Portfolio.last
    # Portfolio Load (0.3ms)  SELECT "portfolios".* FROM "portfolios" ORDER BY "portfolios"."id" DESC LIMIT $1  [["LIMIT", 1]]

    portfolio_two
    # => #<Portfolio id: 8, title: "Portfolio title: 7", subtitle: "The Wings of the Dove", body: "Voluptas debitis perspiciatis. Ipsa mollitia inven...", main_image: "https://via.placeholder.com/600x400", thumb_image: "https://via.placeholder.com/350x200", created_at: "2020-11-30 20:08:02", updated_at: "2020-11-30 20:08:02">

    portfolio_two.destroy
    # (9.2ms)  BEGIN
    #  Portfolio Destroy (0.3ms)  DELETE FROM "portfolios" WHERE "portfolios"."id" = $1  [["id", 8]]
    # (0.5ms)  COMMIT
    # => #<Portfolio id: 8, title: "Portfolio title: 7", subtitle: "The Wings of the Dove", body: "Voluptas debitis perspiciatis. Ipsa mollitia inven...", main_image: "https://via.placeholder.com/600x400", thumb_image: "https://via.placeholder.com/350x200", created_at: "2020-11-30 20:08:02", updated_at: "2020-11-30 20:08:02">
  ```

- Difference between `delete` and `destroy`:

  - `Delete` and `Destroy`, Deletes the record in the database and freezes this instance to reflect that no changes should be made (since they can't be persisted).
  - With **Destroy**, there's a series of `callbacks` associated with destroy. If the `before_destroy` callback throws `:abort` the action is cancelled and destroy returns `false`.
  - With destroy, If I try to delete some record, but in other part of my code, we want to protect this record, this will throw an error

- With destroy action, we don't need to create a view because destroy only deletes the record and redirect to another page
- In `app/controllers/portfolios_controller.rb`

  - Let's create our `destroy` action

    ```Ruby
      def destroy
        # Perform lookup
        @portfolio_item = Portfolio.find(params[:id])

        # Destroy/delete the record
        @portfolio_item.destroy

        # Redirect
        respond_to do |format|
          format.html { redirect_to portfolios_url, notice: 'Your portfolio has been deleted' }
        end
      end
    ```

- In `app/views/portfolios/index.html.erb`

  ```HTML
    <%= link_to 'Delete Portfolio Item', portfolio_path(portfolio_item), method: :delete, data: {confirm: 'Are you sure?'} %>
  ```

  - `link_to` = `<a>` tag
  - `'Delete Portfolio'` = `<a>` tag text
  - `portfolio_path(portfolio_item)` = regular path, we could user a syntax sugar and use just `portfolio`
  - `method: :delete` = This tells our system that we want to delete this record
  - `data: {confirm: 'Are you sure?'}` = a little bit of JavaScript that will popup a confirmation window

  ```HTML
    <h1>Portfolio Items</h1>

    <%= link_to "Create New Item", new_portfolio_path %>

    <p><%= new_portfolio_path %></p>
    <p><%= new_portfolio_url %></p>

    <% @portfolio_items.each do |portfolio_item| %>
      <p><%= link_to portfolio_item.title, portfolio_path(portfolio_item) %></p>
      <p><%= portfolio_item.subtitle %></p>
      <p><%= portfolio_item.body %></p>
      <p><%= image_tag portfolio_item.thumb_image if !portfolio_item.thumb_image.nil? %></p>
      <%= link_to "Edit", edit_portfolio_path(portfolio_item) %>
      <%= link_to 'Delete Portfolio Item', portfolio_path(portfolio_item), method: :delete, data: {confirm: 'Are you sure?'} %>
    <% end %>
  ```

#### Routes

[Go Back to Contents](#contents)

- By default rails creates a route `pages/home` that is our first page (landing page)
- This is not very intuitive, so we can define the root route of application
- **NOTE** every time we change the `route.rb` file, we need to restart the server

- In `config/routes.rb`

  - Instead of using:

    ```Ruby
      Rails.application.routes.draw do
        resources :portfolios
        get 'pages/home'
        get 'pages/about'
        get 'pages/contact'
        resources :blogs
      end
    ```

  - We can define the root route of our app

    - In this case we are pointer to our `pages_controller.rb` (controller) and defining the `home` action

    ```Ruby
      Rails.application.routes.draw do
        resources :portfolios
        get 'pages/about'
        get 'pages/contact'
        resources :blogs

        root to: 'pages#home'
      end
    ```

##### MAPPING ROUTES

[Go Back to Contents](#contents)

- To render the about page we could navigate through [http://localhost:3000/pages/about](http://localhost:3000/pages/about)
- But this is not very intuitive, since we need to add `/pages/about`, because our root is pointing this way (`get 'pages/about'`)
- We can change the path of our page and point to any route we want

  - How rails works, if we don't specify `to:` rails understands that `pages/contact` the left side (`pages`) is the controllers and the right side is (`contact`) is the action

  ```Ruby
    Rails.application.routes.draw do
      resources :portfolios
      # get 'pages/about'
      get 'about', to: 'pages#about'
      # get 'pages/contact'
      get 'contact', to: 'pages#contact'
      resources :blogs

      root to: 'pages#home'
    end
  ```

  ![](https://i.imgur.com/2ebve2W.png)

  ![](https://i.imgur.com/tDxWz5j.png)

- We can check if our changes worked

  ```Bash
    rake routes
  ```

  - Or through the browser [http://localhost:3000/rails/info/routes](http://localhost:3000/rails/info/routes)

    ![](https://i.imgur.com/BIEeT9L.png)
