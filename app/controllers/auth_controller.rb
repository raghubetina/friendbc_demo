require 'open-uri'

class AuthController < ApplicationController
  def facebook
    app_id = "149705581903855"
    app_secret = "9892ab887a2c08477ac8536c457a45e8"
    redirect_uri = "http://localhost:3000/auth/facebook"

    access_token_endpoint = "https://graph.facebook.com/oauth/access_token?client_id=#{app_id}&redirect_uri=#{redirect_uri}&client_secret=#{app_secret}&code=#{params[:code]}"

    result = open(access_token_endpoint).read
  end
end
