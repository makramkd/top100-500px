# README: Top 100 Showcase for 500px
## Introduction
This is a simple web application that does the following:

* Dynamically displays the Top 100 photos sorted by rating in 500px's Popular photo stream. 
* Allows the user to login using 500px's OAuth1.0a support, and through that, the user can favorite photos in the showcase by clicking the 'Favorite' button under each photo.
* The user can also logout. 

## Application information

* Ruby version: `ruby 2.3.1p112 (2016-04-26 revision 54768)`

* System dependencies: none in particular

* Configuration: see `config/initializers/omniauth.rb` for the OmniAuth configuration.

* Database creation: run database migrations using `bundle exec rake db:migrate`. We're using SQLite3 as a development database and PosgreSQL as the production one because we are deploying to Heroku.

* Database initialization

* How to run the test suite: `bundle exec rake test`

* Services (job queues, cache servers, search engines, etc.): none

* Deployment instructions: clone the repository, add the following environment variables to your machine:
  * `MYFIVEHUNDRED_CONSUMER_KEY`: consumer key obtained from registering the application with 500px.
  * `MYFIVEHUNDRED_CONSUMER_SECRET`: consumer secret obtained from registering the application with 500px.
  * `USERNAME` and `PASSWORD`: credentials at 500px in order to use the XAuth authentication process which as far as I know is required for doing API calls such as `get photos`, but I am most likely wrong about that.

    Then, you have to run `bundle install --without production` and `rails s`. 


