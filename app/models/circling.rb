# == Schema Information
#
# Table name: circlings
#
#  id         :integer          not null, primary key
#  circle_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Circling < ActiveRecord::Base
  belongs_to :circle
  belongs_to :user

  validates :circle_id, presence: true
  validates :user_id,   presence: true
end
