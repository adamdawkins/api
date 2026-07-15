class AddQcForProjectIdToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :qc_for_project_id, :integer
  end
end
