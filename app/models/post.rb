class Post < ActiveRecord::Base
  validates :post_facebook_id, uniqueness: true
  validates :link, presence: true
  validates :user, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy
end
