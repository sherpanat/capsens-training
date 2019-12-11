class ChangeCategoryNullToProjects < ActiveRecord::Migration[6.0]
  def change
    change_column_null :projects, :category_id, true
  end
end
