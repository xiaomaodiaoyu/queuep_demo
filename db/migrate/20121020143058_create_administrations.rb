class CreateAdministrations < ActiveRecord::Migration
  def change
    create_table :administrations do |t|
      t.integer :managinggroup_id
      t.integer :admin_id

      t.timestamps
    end

    add_index :administrations, :managinggroup_id
    add_index :administrations, :admin_id
    add_index :administrations, [:admin_id, :managinggroup_id], unique: true
  end
end
