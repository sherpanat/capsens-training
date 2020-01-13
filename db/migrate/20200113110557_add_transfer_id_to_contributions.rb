class AddTransferIdToContributions < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :transfer_id, :string
  end
end
