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

require 'test_helper'

class CircleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
