class AddLandscapeDataToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :landscape_data, :text
  end
end
