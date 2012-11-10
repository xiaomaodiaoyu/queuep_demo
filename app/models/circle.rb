# == Schema Information
#
# Table name: circles
#
#  id                   :integer          not null, primary key
#  group_id             :integer
#  name                 :string(255)
#  creator_id           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  last_update_admin_id :integer
#

class Circle < ActiveRecord::Base
  attr_accessible :name

  validates :name,       presence: true, length: { maximum: 50 },
                         uniqueness: { case_sensitive: false, scope: :group_id }
  validates :group_id,   presence: true
  validates :creator_id, presence: true
  validates :last_update_admin_id,   presence: true

  belongs_to :group
  has_many   :circlings, dependent: :destroy
  has_many   :users,     through: :circlings
end
