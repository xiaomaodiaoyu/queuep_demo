class AddIndexToTokensUserId < ActiveRecord::Migration
  def change
  	add_index :tokens, :user_id, unique: true
  end
end
