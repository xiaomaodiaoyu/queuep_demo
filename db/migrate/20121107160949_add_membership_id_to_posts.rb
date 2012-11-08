class AddMembershipIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :membership_id, :integer
  end
end
