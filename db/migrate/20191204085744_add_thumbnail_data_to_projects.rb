class AddThumbnailDataToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :thumbnail_data, :text
  end
end
