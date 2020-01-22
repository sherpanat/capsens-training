class RenameTransferIdColumnToTransferToContributionWalletId < ActiveRecord::Migration[6.0]
  def change
    rename_column :contributions, :transfer_id, :transfer_to_contribution_wallet_id
  end
end
