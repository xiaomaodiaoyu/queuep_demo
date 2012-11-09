class CreateCircles < ActiveRecord::Migration
  def change
    create_table :circles do |t|
      t.integer :group_id
      t.string :name
      t.integer :creator_id

      t.timestamps
    end
  end
end
