class AddAuthToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :auth, :boolean, default: false
  end
end
