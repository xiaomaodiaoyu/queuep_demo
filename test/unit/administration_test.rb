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

require 'test_helper'

class AdministrationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
