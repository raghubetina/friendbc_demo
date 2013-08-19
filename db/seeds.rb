# Write some logic in here to pull data from the Facebook API and store it in our database.

# For each user
  # Pull the user's home feed
  # For each post in the home feed,
    # If the post contains a video,
      # Create a new row in the posts table and populate it with API data
      # Associate the post with the correct user
      # Save the row
      # If the post has comments,
        # For each comment,
          # Create a new row in the comments table and populate it with API data
          # Associate the comment with the correct post
          # Save the row
