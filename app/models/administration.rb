# == Schema Information
#
# Table name: administrations
#
#  id               :integer          not null, primary key
#  managinggroup_id :integer
#  admin_id         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Administration < ActiveRecord::Base
  attr_accessible :admin_id, :managinggroup_id

  belongs_to :admin,         class_name: "User"
  belongs_to :managinggroup, class_name: "Group"

  validates :managinggroup_id, presence: true
  validates :admin_id,         presence: true
end
