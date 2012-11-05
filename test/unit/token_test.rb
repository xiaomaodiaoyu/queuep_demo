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

require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
