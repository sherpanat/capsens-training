class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :short_description
      t.text :long_description
      t.integer :target_amount, default: 0
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
