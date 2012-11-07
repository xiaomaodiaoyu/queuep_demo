class DropAdministrations < ActiveRecord::Migration
  def change
    drop_table :administrations
  end
end
