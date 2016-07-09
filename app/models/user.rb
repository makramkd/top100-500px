class User < ActiveRecord::Base

  def self.create_with_omniauth_hash(auth_hash)
    # create a user with the given information in the omniauth auth hash
    user = new
    user.provider = auth_hash['provider']
    user.uid = auth_hash['uid']
    if auth_hash['info']
      user.name = auth_hash['info']['name'] || ""
    end
    user.save

    # return the user to the caller
    user
  end
end
