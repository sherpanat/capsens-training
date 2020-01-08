class AddWalletIdsToUsersAndProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :wallet_id, :string
    add_column :projects, :wallet_id, :string
  end
end
