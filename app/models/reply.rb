# == Schema Information
#
# Table name: replies
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :decimal(8, 2)
#  post_id    :integer
#  lat        :float
#  lng        :float
#  location   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Reply < ActiveRecord::Base
  attr_accessible :content, :lat, :lng, :location
  validates :user_id,  presence: true
  validates :post_id,  presence: true
  validates :content,  presence: true, numericality: true
  validates :lat,      presence: true, numericality: true
  validates :lng,      presence: true, numericality: true
  validates :location,  presence: true

  belongs_to :user
  belongs_to :post
end
