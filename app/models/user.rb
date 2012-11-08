# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  first_name      :string(255)
#  last_name       :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :password, :first_name, :last_name
  has_secure_password

  before_save { |user| user.email = email.downcase }

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name,  presence: true, length: { maximum: 50 }
  validates :password,   length: { minimum: 6 }, :if => :validate_password?

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,      presence: true, format: { with: VALID_EMAIL_REGEX },
                         uniqueness: { case_sensitive: false }

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships, source: :group
  has_many :managing_groups, through: :memberships, 
           source: :group, conditions: ["memberships.admin = ?", true]
  has_many :posts, dependent: :destroy
  has_one  :token, dependent: :destroy

  def creator_join!(group)
    @membership = self.join!(group)
    @membership.toggle!(:auth)
    @membership.toggle!(:admin)
  end

  def join!(group)
    memberships.create!(group_id: group.id)
  end 


private
  def validate_password?
    self.password
  end

end
