class ShowcaseController < ApplicationController
  def index
    # create the access token to make a request
    access_token = create_access_token

    # get the 100 most popular photos
    response = create_api_get_request access_token,
                                      "/photos?feature=popular&sort=rating&rpp=100&image_size=3&include_store=store_download&include_states=voted"

    # set the image_urls member so that we can render the photos
    # in the view
    @image_id_url_array = image_urls response
  end

  def favorite_photo
    image_id = params[:img_id]

    logger.debug session.inspect

    user_access_token = session[:user_access_token]
    user_access_token_secret = session[:user_access_token_secret]
    user_actual_access_token = session[:user_actual_access_token]

    # make sure we have the right information to send a post request
    if !user_actual_access_token.nil?
      consumer = OAuth::Consumer.new CONSUMER_KEY, CONSUMER_SECRET, {
          :site               => BASE_URL,
          :request_token_path => REQUEST_TOKEN_PATH,
          :access_token_path  => ACCESS_TOKEN_PATH,
          :authorize_path     => AUTHORIZE_PATH
      }

      # since we already have the access token from oauth we use that to get a new
      # access token
      access_token = OAuth::AccessToken.new consumer, session[:user_access_token].to_s,
          session[:user_access_token_secret].to_s

      # make the post request
      create_api_post_request access_token, "/photos/#{image_id}/favorite"

      redirect_to root_url, notice: 'Favorited photo!'
    else
      # TODO add a good way to show that we are unauthorized
      # (maybe don't even show the button - i think thats best)
      logger.debug 'Not authorized yet: please login'
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  private

  # information needed to use the 500px api
  CONSUMER_KEY = ENV["MYFIVEHUNDRED_CONSUMER_KEY"]
  CONSUMER_SECRET = ENV["MYFIVEHUNDRED_CONSUMER_SECRET"]
  USERNAME = ENV["FIVE_USERNAME"]
  PASSWORD = ENV["FIVE_PASSWORD"]

  # path constants
  BASE_URL = "https://api.500px.com/v1"
  REQUEST_TOKEN_PATH = "/oauth/request_token"
  ACCESS_TOKEN_PATH = "/oauth/access_token"
  AUTHORIZE_PATH = "/oauth/authorize"

  def create_access_token
    consumer = OAuth::Consumer.new CONSUMER_KEY, CONSUMER_SECRET, {
        :site               => BASE_URL,
        :request_token_path => REQUEST_TOKEN_PATH,
        :access_token_path  => ACCESS_TOKEN_PATH,
        :authorize_path     => AUTHORIZE_PATH
    }

    request_token = consumer.get_request_token

    access_token = consumer.get_access_token request_token, {}, {
        :x_auth_mode => 'client_auth', :x_auth_username => USERNAME, :x_auth_password => PASSWORD
    }
    access_token
  end

  # create a get request and return the body of the response.
  # this is used to get the top 100 photos
  def create_api_get_request(access_token, request)
    response = access_token.get request
    response.body
  end

  # create a post request and return the body of the response
  # this is intended to be used with a "favorite" action on the app
  def create_api_post_request(access_token, request)
    response = access_token.post request
    response.body
  end

  def image_urls(json_response)
    parsed_json = JSON.parse(json_response)
    photos_json_array = parsed_json["photos"]
    image_url_array = []
    photos_json_array.each { |photo|
      image_url_array << [photo['id'], photo["image_url"]]
    }

    image_url_array
  end
end
