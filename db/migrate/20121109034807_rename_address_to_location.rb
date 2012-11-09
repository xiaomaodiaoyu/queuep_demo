class RenameAddressToLocation < ActiveRecord::Migration
  def change
    rename_column :replies, :address, :location
  end
end
