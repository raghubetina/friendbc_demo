require 'open-uri'

class AuthController < ApplicationController
  def facebook
    app_id = ENV['FRIENDBC_APP_ID']
    app_secret = ENV['FRIENDBC_APP_SECRET']
    redirect_uri = "http://localhost:3000/auth/facebook"

    access_token_endpoint = "https://graph.facebook.com/oauth/access_token?client_id=#{app_id}&redirect_uri=#{redirect_uri}&client_secret=#{app_secret}&code=#{params[:code]}"

    result = open(access_token_endpoint).read
    parsed_result = Rack::Utils.parse_query(result)

    current_user.facebook_access_token = parsed_result["access_token"]
    current_user.save

    redirect_to user_url(current_user)
  end

  def twitter
    current_user.twitter_access_key = request.env['omniauth.auth'].extra.access_token.token
    current_user.twitter_access_secret = request.env['omniauth.auth'].extra.access_token.secret
    current_user.save

    redirect_to root_url
  end
end
