class ShowcaseController < ApplicationController
  def index
    # create the access token to make a request
    access_token = create_access_token

    # get the 100 most popular photos
    response = create_api_request access_token,
                                  "/photos?feature=popular&sort=created_at&rpp=100&image_size=3&include_store=store_download&include_states=voted"

    # set the image_urls member so that we can render the photos
    # in the view
    @image_urls = image_urls response
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

  def create_api_request(access_token, request)
    response = access_token.get request
    response.body
  end

  def image_urls(json_response)
    parsed_json = JSON.parse(json_response)
    photos_json_array = parsed_json["photos"]
    image_url_array = []
    photos_json_array.each { |photo|
      image_url_array << photo["image_url"]
    }

    image_url_array
  end
end
