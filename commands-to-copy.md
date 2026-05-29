# Cheat Sheet
  This document is meant to make copying commands easier for workshop participants. Each command shown in the slides should be in this document

## Initialization Steps
1. Build the docker instance
   ```
   docker build -t rails2hanami .
   ```

1. Run the docker instance
   ```
   docker run -it --name rails2hanami --publish 3001:3000 --publish 2301:2300 --volume .:/usr/src/app rails2hanami
   ```

1. Setup the databases
   ```
   docker exec -it rails2hanami bundle exec rails db:migrate
   ```

## Run the rails tests

   ```
   docker exec -it rails2hanami bundle exec rspec
   ```

## Workshop steps

### Initial Application Setup

1. Generate the app
   ```
   docker exec -w /usr/src/app -it rails2hanami bash
   ```

   ```
   hanami new bookshelf
   ls bookshelf
   exit
   ```

1. Setup and run the new Hanami application
   install the dependencies
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami npm install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami assets compile
   ```
   run the Hanami dev server
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
   ```

1. 1. check out the [hanami application](http://localhost:2301)

1. Seed the Rails database and copy it over to Hanami
   ```
   docker exec -it rails2hanami bundle exec rails db:seed
   docker exec -w /usr/src/app/bookshelf -it rails2hanami cp ../rails_bookshelf/storage/development.sqlite3 db/
   docker exec -w /usr/src/app/bookshelf -it rails2hanami cp ../rails_bookshelf/storage/test.sqlite3 db/
   ```

1. In bookshelf/.env replace all with the following
   ```
   DATABASE_URL=sqlite://db/development.sqlite3
   ```

1. Connect to the database in the Hanami application
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami generate relation books
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami console
   ```

   ```
   Hanami.app["relations.books"].to_a
   ```

   ```
   exit
   ```

1. Copy over the system specs
   ```
   docker exec -it rails2hanami cp -r spec/system ../bookshelf/spec/
   ```

1. run all the tests
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec
   ```
1. Replace in bookshelf/spec
   ```
   require "rails_helper"
   ```
   With
   ```
   require "spec_helper"
   ```
1. Add Byebug to the Hanami app

   Add to Gemfile
   ```
   gem "byebug"
   ```

   Run bundle install
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle install
   ```

1. Create the book repo
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami generate repo book
   ```

1. Add to bookshelf/app/repos/book_repo.rb inside the Class 
   ```
   def create(attributes)
     attributes[:created_at] = Time.now
     attributes[:updated_at] = Time.now
     books.changeset(:create, attributes).commit
   end
        
   def last = books.last
   def get(id) = books.by_pk(id).one!
   ```

1. Replace in bookshelf\spec
   ```
   Book.create(
   ```
   With
   ```
   Bookshelf::Repos::BookRepo.new.create(
   ```

1. Replace in bookshelf\spec
   ```
   Book.last
   ```
   With
   ```
   Bookshelf::Repos::BookRepo.new.last
   ```

#### working initial setup

1. Check out the completed code branch
   ```
   mv bookshelf bookshelf_init
   git reset --hard origin/initial-setup
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami npm install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami assets compile
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec
   ```

### Book Show

1. Run the Show spec (keep running this until it passes)
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_show_spec.rb
   ```

1. Generate Show action
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami generate action books.show --skip-tests 
   ```

   Add the name to the route `get "/books/:id", to: "books.show"` in config/routes.rb
   ```
   , as: "book"
   ```

1. Copy the show view
   ```
   docker exec -it rails2hanami cp app/views/books/show.html.erb ../bookshelf/app/templates/books/
   docker exec -it rails2hanami cp app/views/books/_book.html.erb ../bookshelf/app/templates/books/
   ```

1. Replace in bookshelf/app/templates/books/show.html.erb
   ```
   notice
   ```
   With 
   ```
   flash[:notice]
   ```

1. Allow cookies in bookshelf/config/app.rb
   ```
   config.actions.sessions = :cookie, { key: "bookshelf.session", secret: settings.session_secret, expire_after: 60*60*24*365 }
   ```

1. Add the secret in bookshelf/config/settings.rb
   ```
   setting :session_secret, constructor: Types::String
   ```

1. Add the value in bookshelf/.env
   ```
   SESSION_SECRET=____local_development_secret_only____local_development_secret_only___
   ```

1. Replace in bookshelf/app/templates/books/show.html.erb
   ```
   <%= render @book %>
   ```
   With 
   ```
   <%= render "book", book: book %>
   ```

1. Add to bookshelf/app/views/books/show.rb
   ```
   include Deps["repos.book_repo"]

   expose :book do |id:|
     book_repo.get(id)
   end
   ```

1. Create a Book struct
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami generate struct book
   ```

1. Add to bookshelf/app/structs/book.rb
   ```
   def dom_id
     "book_#{id}"
   end
   ```

1. Replace in bookshelf/app/templates/books/_book.html.erb
   ```
   <%= dom_id book %>
   ```
   With
   ```
   <%= book.dom_id %> 
   ```

1. Generate index, edit and destroy actions
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami generate action books.edit --skip-tests
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami generate action books.destroy --skip-tests 
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami generate action books.index --skip-tests 
   ```

1. Add the name to the route `get "/books/:id/edit", to: "books.edit"` in config/routes.rb
   ```
   , as: "edit_book"
   ```

1. Add the name to the route `delete "/books/:id", to: "books.destroy"` in config/routes.rb
   ```
   , as: "destroy_book"
   ```

1. Add the name to the route `get "/books", to: "books.index"` in config/routes.rb
   ```
   , as: "books"
   ```

1. Replace in bookshelf/app/templates/books/show.html.erb
   ```
   edit_book_path(@book) 
   ```
   With 
   ```
   routes.path(:edit_book, id: book.id)
   ```

1. Replace in bookshelf/app/templates/books/show.html.erb
   ```
   books_path
   ```
   With 
   ```
   routes.path(:books)
   ```

1. Replace in in bookshelf/app/templates/books/show.html.erb
   ```
   <%= button_to "Destroy this book", @book, method: :delete %>
   ```
   With
   ```
   <%= form_for :book, routes.path(:destroy_book, id: book.id), method: :delete do |f| %>
     <%= f.submit "Destroy this book" %>
   <% end %>
   ```
1. Restart the Hanami server by going to the terminal and hitting `ctrl-c` and then rerunning the hanami command
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
   ```

1. check out the [show page in the application](http://localhost:2301/books/1)

#### Working Show

1. Stop the Hanami server by going to the terminal and hitting `ctrl-c`
1. Check out the completed code branch
   ```
   mv bookshelf bookshelf_my_show
   git reset --hard origin/book-show
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami npm install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami assets compile
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_show_spec.rb
   ```
1. Start the hanami dev server
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
   ```

### Books Index

1. Copy over the rails view for index
   ```
   docker exec -it rails2hanami cp app/views/books/index.html.erb ../bookshelf/app/templates/books/
   ```

1. run the Index spec (keep running this until it passes)
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_index_spec.rb
   ```

1. Replace in bookshelf/app/templates/books/index.html.erb
   ```
   notice
   ```
   With 
   ```
   flash[:notice]
   ```

 1. Add to bookshelf/app/views/books/index.rb
    ```
    include Deps["repos.book_repo"]

    expose :books do
      book_repo.books.to_a
    end
    ```

1. Replace in bookshelf/app/templates/books/index.html.erb
   ```
   @books
   ```
   With 
   ```
   books
   ```

1. Replace in bookshelf/app/templates/books/index.html.erb
   ```
   <%= render book %>
   ```
   With 
   ```
   <%= render "book", book: book %>
   ```

1. Replace in bookshelf/app/templates/books/index.html.erb
   ```
   <%= link_to "Show this book", book %>
   ```
   With 
   ```
   <%= link_to "Show this book", routes.path(:book, id: book.id) %>
   ```

1. Generate a new action
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami generate action books.new --skip-tests
   ```
   
   Add the name to the route `get "/books/new", to: "books.new"` in config/routes.rb
   ```
   , as: "new_book"
   ```

1. Replace in bookshelf/app/templates/books/index.html.erb
   ```
   new_book_path
   ```
   With 
   ```
   routes.path(:new_book)
   ```
1. check out the [index page in the application](http://localhost:2301/books)

#### Working Index

1. Stop the Hanami server by going to the terminal and hitting `ctrl-c`
1. Check out the completed code branch
   ```
   mv bookshelf bookshelf_my_index
   git reset --hard origin/book-index
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami npm install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami assets compile
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_index_spec.rb
   ```
1. Start the hanami dev server
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
   ```

### Application Layout

1. Copy over the rails layout
   ```
   docker exec -it rails2hanami cp app/views/layouts/application.html.erb ../bookshelf/app/templates/layouts/app.html.erb
   docker exec -it rails2hanami cp app/assets/stylesheets/application.css ../bookshelf/app/assets/css/app.css
   ```
1. remove the following lines in bookshelf/app/templates/layouts/app.html.erb as Hanami does Content Security by default
   ```
   <%= csp_meta_tag %>
   ```
1. We will utilize the hanami icon so we can tell our tabs apart. Remove the following lines
   ```
       <link rel="icon" href="/icon.png" type="image/png">
       <link rel="icon" href="/icon.svg" type="image/svg+xml">
       <link rel="apple-touch-icon" href="/icon.png">
   ```

1. Replace the following in bookshelf/app/templates/layouts/app.html.erb
   ```
   <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>
       <%= javascript_importmap_tags %>
   ```
   With
   ```
   <%= favicon_tag %>
   <%= stylesheet_tag "app" %>
   ```
1. Replace the following in bookshelf/app/templates/layouts/app.html.erb
   ```
   <%= csrf_meta_tags %>
   ```
   With
   ```
   <%= csrf_meta_tags&.html_safe %>
   ```
1. Compile the assets
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami assets compile
   ```
1. Restart the Hanami server by going to the terminal and hitting `ctrl-c` and then rerunning the hanami command
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
   ```

1. check out the [index page in the application](http://localhost:2301/books)

#### Working Layout

1. Stop the Hanami server by going to the terminal and hitting `ctrl-c`
1. Check out the completed code branch
   ```
   mv bookshelf bookshelf_my_layout
   git reset --hard origin/app-layout
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami npm install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami assets compile
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_index_spec.rb
   ```
1. Start the hanami dev server
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
   ```

### Book New
1. Copy over the New views
   ```
   docker exec -it rails2hanami cp app/views/books/new.html.erb ../bookshelf/app/templates/books/
   docker exec -it rails2hanami cp app/views/books/_form.html.erb ../bookshelf/app/templates/books/
   ```

1. Run the Create test (keep running it until it passes)
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_create_spec.rb
   ```

1. Replace line 1 in bookshelf/app/templates/books/_form.html.erb with
   ```
    <%= form_for :book, routes.path(:create_book), method: "POST" do |form| %>
   ```

1. Generate the create action
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami generate action books.create --skip-tests
   ```

   Add the name to the route `get "/books/new", to: "books.new"` in config/routes.rb
   ```
   , as: "create_book"
   ```

1. Replace in bookshelf/app/templates/books/new.html.erb
   ```
   @book
   ```
   With
   ```
   book
   ```
1. Add to bookshelf/app/views/books/new.rb
   ```
   include Deps["repos.book_repo"]

   expose :book do |context:|
     context.request.params[:book]
   end
   ```
1. Replace in bookshelf/app/templates/books/new.html.erb
   ```
   books_path
   ```
   With
   ```
   routes.path(:books)
   ```

1. Replace in bookshelf/app/templates/books/_form.html.erb
   ```
   form.submit
   ```
   With
   ```
   form.submit "Create Book"
   ```

1. Copy the rails logic into bookshelf/app/actions/books/create.rb handle method from rails_bookshelf/app/controllers/books_controller.rb#create
   Handle method will look like:
   ```
   def handle(request, response)
     @book = Book.new(book_params)
     if @book.save
       redirect_to @book, notice: "Book was successfully created."
     else
       render :new, status: :unprocessable_entity
     end
   end
   ```

1. Add in bookshelf/app/actions/books/create.rb inside `class Create < Bookshelf::Action`
   ```
   include Deps["repos.book_repo"]

   params do
      required(:book).hash do
         required(:title).filled(:string)
         required(:author).filled(:string)
      end
   end
   ```

1. Change the handle code to validate parameters and utilize the book repo
   ```
   def handle(request, response)
     if request.params.valid?
        book = book_repo.create(request.params[:book])
        response.flash[:notice] = "Book was successfully created"
        response.redirect_to routes.path(:book, id: book[:id])
     else
       response.flash.now[:alert] = "Could not create book"
     end
   end
   ```

1. Restart the Hanami server by going to the terminal and hitting `ctrl-c` and then rerunning the hanami command
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
   ```

1. check out the [index page in the application](http://localhost:2301/books) and make a new book


#### Working New

1. Stop the Hanami server by going to the terminal and hitting `ctrl-c`
1. Check out the completed code branch
   ```
   mv bookshelf bookshelf_my_new
   git reset --hard origin/book-new
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami npm install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami assets compile
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_create_spec.rb
   ```
1. Start the hanami dev server
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
   ```

### Exercise 1

1. Run the delete test (keep running it until it passes)
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_delete_spec.rb
   ```

#### Exercise 1 Hints

1. There is an example in the [Hanami docs for deleting a Book](https://hanakai.org/learn/hanami/v2.3/getting-started/building-a-web-app#deleting-a-book)

1. Code to delete a book that can be added to the relation
   ```
   def delete(id)
     books.by_pk(id).changeset(:delete).commit
   end
   ```

1. All elements are already visible to the user.  The link for deletion is on the show page

#### Working Delete

1. Stop the Hanami server by going to the terminal and hitting `ctrl-c`
1. Check out the completed code branch
   ```
   mv bookshelf bookshelf_my_delete
   git reset --hard origin/book-delete
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami npm install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami assets compile
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_delete_spec.rb
   ```
1. Start the hanami dev server
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
   ```

### Exercise 2

1. Run the edit test (keep running it until it passes)
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_edit_spec.rb
   ```

#### Exercise 2 Hints

1. There is an example in the [Hanami docs for updating a Book](https://hanakai.org/learn/hanami/v2.3/getting-started/building-a-web-app#updating-a-book)

1. You can generate the update action with the following command
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami generate action books.update --skip-tests
   ```

#### Working Edit

1. Stop the Hanami server by going to the terminal and hitting `ctrl-c`
1. Check out the completed code branch
   ```
   mv bookshelf bookshelf_my_edit
   git reset --hard origin/book-edit
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami npm install
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami assets compile
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec rspec spec/system/book_edit_spec.rb
   ```
1. Start the hanami dev server
   ```
   docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
   ```
