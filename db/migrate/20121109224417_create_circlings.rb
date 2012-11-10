class CreateCirclings < ActiveRecord::Migration
  def change
    create_table :circlings do |t|
      t.integer :circle_id
      t.integer :user_id

      t.timestamps
    end
  end
end
