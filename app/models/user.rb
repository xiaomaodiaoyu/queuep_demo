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
  #before_save :create_remember_token

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name,  presence: true, length: { maximum: 50 }
  validates :password,   length: { minimum: 6 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,      presence: true, format: { with: VALID_EMAIL_REGEX },
                         uniqueness: { case_sensitive: false }

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships, source: :group
  has_one  :token, dependent: :destroy

  has_many :administrations, foreign_key: "admin_id", dependent: :destroy
  has_many :managinggroups, through: :administrations
  

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
