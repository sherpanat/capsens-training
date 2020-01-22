class AddIdentityColumnsToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :owner_first_name, :string
    add_column :projects, :owner_last_name, :string
    add_column :projects, :owner_birthdate, :date
    add_column :projects, :email, :string
    add_column :projects, :mangopay_id, :string
  end
end
