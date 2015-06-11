class AddArtifactActionViewerToArtifacts < ActiveRecord::Migration
  def change
    add_column :artifacts, :artifact_action_viewer, :string
  end
end
