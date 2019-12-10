class AddCounterpartToContributions < ActiveRecord::Migration[6.0]
  def change
    add_reference :contributions, :counterpart, foreign_key: true
  end
end
