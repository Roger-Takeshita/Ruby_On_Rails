<h1 id='contents'>Table of Contents</h1>

- [PROJECT 001 - PORTFOLIO](#project-001---portfolio)
  - [Start New Project](#start-new-project)
    - [Start Server](#start-server)
    - [Scafflold](#scafflold)

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

### Scafflold

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
