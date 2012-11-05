class RemoveParentIdFromGroups < ActiveRecord::Migration
  def change
  	remove_column :groups, :parent_id
    remove_column :groups, :lft
    remove_column :groups, :rgt
    remove_column :groups, :depth
  end
end
