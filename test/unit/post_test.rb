# == Schema Information
#
# Table name: posts
#
#  id            :integer          not null, primary key
#  content       :string(255)
#  user_id       :integer
#  group_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  membership_id :integer
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end