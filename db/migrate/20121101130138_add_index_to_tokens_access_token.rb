class AddIndexToTokensAccessToken < ActiveRecord::Migration
  def change
  	add_index :tokens, :access_token, unique: true
  end
end
