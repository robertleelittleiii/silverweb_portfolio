class AddPositionToArtifacts < ActiveRecord::Migration
  def self.up
    add_column :artifacts, :position, :integer
    add_column :artifacts, :artifact_active, :boolean

  end

  def self.down
    remove_column :artifacts, :position
        remove_column :artifacts, :artifact_active

  end
end
