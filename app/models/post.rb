# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  belongs_to :group
  has_many :replies, dependent: :destroy

  validates :user_id, presence: true
  validates :group_id, presence: true
  validates :content,  presence: true, length: { maximum: 500 }

  default_scope order: 'posts.created_at DESC'

=begin
  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
  	followed_user_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"

	where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
           user_id: user.id)
  end
=end

end
