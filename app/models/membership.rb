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
#  admin      :boolean          default(FALSE)
#

class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :group_id, presence: true
  validates :user_id,  presence: true, uniqueness: { scope: :group_id }
  validates_uniqueness_of :admin, scope: :group_id, :if => :admin_is_true

  private
    def admin_is_true
      self.admin == true
    end
end
