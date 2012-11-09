class AddLastUpdateAdminIdToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :last_update_admin_id, :integer
  end
end
