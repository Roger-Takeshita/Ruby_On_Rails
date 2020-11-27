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

# LINKS

[Go Back to Contents](#contents)

- [Rails Scaffold Templates](https://github.com/rails/rails/tree/master/railties/lib/rails/generators/erb/scaffold/templates)

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

        ```Ruby
          <h1>New Blog</h1>

          <%= render 'form', blog: @blog %>

          <%= link_to 'Back', blogs_path %>
        ```

      - in `app/views/blogs/_form.html.erb`

        ```Ruby
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

  ```Ruby
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
