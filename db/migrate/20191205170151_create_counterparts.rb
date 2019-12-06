class CreateCounterparts < ActiveRecord::Migration[6.0]
  def change
    create_table :counterparts do |t|
      t.integer :threshold
      t.integer :level
      t.string :description
      t.integer :stock
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
