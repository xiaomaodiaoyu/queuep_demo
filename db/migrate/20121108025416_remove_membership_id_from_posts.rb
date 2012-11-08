class RemoveMembershipIdFromPosts < ActiveRecord::Migration
  def change
  	remove_column :posts, :membership_id
  end
end
