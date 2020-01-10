class AddPayinIdToContributions < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :payin_id, :string
  end
end
