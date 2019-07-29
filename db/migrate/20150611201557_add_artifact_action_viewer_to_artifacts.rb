# frozen_string_literal: true

class AddArtifactActionViewerToArtifacts < ActiveRecord::Migration[5.0]
  def change
    add_column :artifacts, :artifact_action_viewer, :string
  end
end
