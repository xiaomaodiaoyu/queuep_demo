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

require 'test_helper'

class ReplyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
