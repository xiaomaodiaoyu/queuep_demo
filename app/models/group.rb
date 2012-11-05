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
  attr_accessible :name, :creator_id, :admin_id
  before_validation :set_initial_admin

  validates :name,       presence: true, length: { maximum: 50 },
                         uniqueness: { case_sensitive: false }
  validates :creator_id, presence: true
  validates :admin_id,   presence: true

  has_many :memberships, dependent: :destroy
  has_many :users,       through: :memberships

  has_many :administrations, foreign_key: "managinggroup_id", dependent: :destroy
  has_many :admins, through: :administrations

private
  def set_initial_admin
    self.admin_id = self.creator_id
  end

end
