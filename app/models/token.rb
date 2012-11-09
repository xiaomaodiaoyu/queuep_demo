# == Schema Information
#
# Table name: tokens
#
#  id           :integer          not null, primary key
#  access_token :string(255)
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Token < ActiveRecord::Base
  before_validation :generate_access_token
  belongs_to        :user

  validates :access_token, presence: true, uniqueness: true
  validates :user_id,      presence: true, uniqueness: true

private

  def generate_access_token
  	begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

end
