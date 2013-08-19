class Comment < ActiveRecord::Base
  validates :comment_facebook_id, uniqueness: true
  validates :post, presence: true

  belongs_to :post
end
