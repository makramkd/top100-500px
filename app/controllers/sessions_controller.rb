class SessionsController < ApplicationController

  def new
    # if its a new session the user has to authenticate (only if they're logging in).
    redirect_to '/auth/500px'
  end

  def create
    # this action is called on a callback so we can get omniauth parameters here
    # the omniauth hash contains information about the user returned from the
    # authentication process. For the full schema of the
    # hash see here: https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
    auth = request.env['omniauth.auth']

    # check if the user has already authenticated with us
    # if not, create the user with the given hash
    find_query = User.find_by_provider_and_uid(auth['provider'], auth['uid'].to_s)
    user = nil
    if find_query
      user = find_query
    else
      user = User.create_with_omniauth_hash(auth)
    end

    # simple logging to make sure info is there
    logger.debug "User attributes: provider: #{user.provider}, name: #{user.name}, uid: #{user.uid}."

    # reset the session parameters
    reset_session

    # set the user id of the current session
    session[:user_id] = user.id

    redirect_to root_url, notice: 'Logged in!'
  end

  def failure
    redirect_to root_url, alert: "Authentication error encountered: #{params[:message].humanize}."
  end

  def destroy
    reset_session
    redirect_to root_url, notice: 'Logged out!'
  end
end
