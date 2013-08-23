require 'open-uri'

namespace :api do
  desc "Fetch Twitter API updates for all users"
  task twitter: :environment do
    User.find_each do |user|
      client = Twitter::REST::Client.new do |config|
        config.consumer_key = 'okpmnwPRavYpZRYz2qBA'
        config.consumer_secret = 'QSuS4quZ6d2iyXqIjVlhdOgjnon5HMIBat0ZaLpJk'
        config.access_token = user.twitter_access_key
        config.access_token_secret = user.twitter_access_secret
      end

      client.home_timeline(count: 200).each do |tweet|
        if tweet.urls.any?
          tweet.urls.map(&:expanded_url).each do |url|
            if url.host.include?('youtube.com') || url.host.include?('vimeo.com')
              post = Post.new
              post.sharer_name = tweet.user.name
              post.sharer_facebook_id = tweet.user.id
              post.message = tweet.text
              post.link = url.to_s
              post.created_time = tweet.created_at
              post.post_facebook_id = tweet.id
              post.user_id = user.id
              post.save
            end
          end
        end
      end
    end
  end

  desc "Fetch Facebook API updates for all users"
  task facebook: :environment do
    User.find_each do |user|
      begin
        url = "https://graph.facebook.com/me/home?access_token=#{user.facebook_access_token}&limit=200"
        raw_response = open(url).read
        parsed_response = JSON.parse(raw_response)
        posts = parsed_response['data'].select { |p| p['type'] == 'video' }
      rescue Exception => e
        puts e
        posts = []
      end

      posts.each do |the_post|
        post = Post.new
        post.sharer_name = the_post['from']['name']
        post.sharer_facebook_id = the_post['from']['id']
        post.message = the_post['message']
        post.link = the_post['link']
        post.created_time = the_post['created_time']
        post.post_facebook_id = the_post['id']
        post.user_id = user.id
        unless post.save
          post = Post.find_by(post_facebook_id: the_post['id'])
        end
        if the_post['comments'].present?
          the_post['comments']['data'].each do |the_comment|
            comment = Comment.new
            comment.commenter_name = the_comment['from']['name']
            comment.commenter_facebook_id = the_comment['from']['id']
            comment.message = the_comment['message']
            comment.created_time = the_comment['created_time']
            comment.comment_facebook_id = the_comment['id']
            comment.post_id = post.id
            comment.save
          end
        end
      end
    end
  end
end
