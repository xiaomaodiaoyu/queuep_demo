class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :user_id
      t.decimal :content, precision: 8, scale: 2
      t.integer :post_id
      t.float :lat
      t.float :lng
      t.string :address

      t.timestamps
    end
  end
end
