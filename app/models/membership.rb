# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  auth       :boolean          default(FALSE)
#

class Membership < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  belongs_to :group
  belongs_to :user

  validates :group_id, presence: true
  validates :user_id,  presence: true
  validates_uniqueness_of :user_id, scope: [:group_id]
end
