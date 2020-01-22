class AddTransferToProjectWalletIdToContributions < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :transfer_to_project_wallet_id, :string
  end
end
