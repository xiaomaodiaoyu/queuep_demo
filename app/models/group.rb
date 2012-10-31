# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  parent_id  :integer
#  lft        :integer
#  rgt        :integer
#  depth      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :integer
#

class Group < ActiveRecord::Base
  attr_accessible :name, :parent_id, :creator_id
  acts_as_nested_set

  validates :name, presence: true, length: { maximum: 50 },
                   uniqueness: { case_sensitive: false }
  validates :creator_id, presence: true

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :administrations, foreign_key: "managinggroup_id", dependent: :destroy
  has_many :admins, through: :administrations
end
