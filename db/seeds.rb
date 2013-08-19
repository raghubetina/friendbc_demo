# Write some logic in here to pull data from the Facebook API and store it in our database.

require 'open-uri'

# For each user
User.all.each do |user|
  # Pull the user's home feed
  begin
    url = "https://graph.facebook.com/me/home?access_token=#{user.facebook_access_token}&limit=200"

    raw_response = open(url).read
    parsed_response = JSON.parse(raw_response)
    posts = parsed_response['data']
  rescue
    next
  end
  # For each post in the home feed,
  posts.each do |post|
    # If the post contains a video,
    if post['type'] == 'video'
      # Create a new row in the posts table and populate it with API data
      p = Post.new
      p.sharer_name = post['from']['name']
      p.sharer_facebook_id = post['from']['id']
      p.message = post['message']
      p.link = post['link']
      p.created_time = post['created_time']
      p.post_facebook_id = post['id']
      # Associate the post with the correct user
      p.user_id = user.id
      # Save the row
      p.save
      # If the post has comments,
      if post['comments'].present?
        # For each comment,
        post['comments']['data'].each do |comment|
          # Create a new row in the comments table and populate it with API data
          c = Comment.new
          c.commenter_name = comment['from']['name']
          c.commenter_facebook_id = comment['from']['id']
          c.message = comment['message']
          c.created_time = comment['created_time']
          c.comment_facebook_id = comment['id']
          # Associate the comment with the correct post
          c.post_id = p.id
          # Save the row
          c.save
        end
      end
    end
  end
end
