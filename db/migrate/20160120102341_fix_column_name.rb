class FixColumnName < ActiveRecord::Migration
  def change
     rename_column :users, :post_id, :access_token
  end
end
