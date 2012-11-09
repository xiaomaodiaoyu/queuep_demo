# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :integer
#  admin_id   :integer
#

class Group < ActiveRecord::Base
  attr_accessible :name
  before_validation :set_initial_admin

  validates :name,       presence: true, length: { maximum: 50 },
                         uniqueness: { case_sensitive: false }
  validates :creator_id, presence: true
  validates :admin_id,   presence: true

  has_many :memberships, dependent: :destroy
  has_many :users,       through: :memberships
  has_many :posts,       dependent: :destroy
  has_many :authorized_users, through: :memberships, 
            source: :user, conditions: ["memberships.auth = ?", true]
  has_many :circles,     dependent: :destroy

private
  def set_initial_admin
    if !self.admin_id
      self.admin_id = self.creator_id
    end
  end

end
