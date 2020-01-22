class AddWalletIdToContributions < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :wallet_id, :string
  end
end
