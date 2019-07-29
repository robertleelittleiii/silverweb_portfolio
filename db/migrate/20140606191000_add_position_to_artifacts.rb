# frozen_string_literal: true

class AddPositionToArtifacts < ActiveRecord::Migration[5.0]
  def self.up
    add_column :artifacts, :position, :integer
    add_column :artifacts, :artifact_active, :boolean
  end

  def self.down
    remove_column :artifacts, :position
    remove_column :artifacts, :artifact_active
  end
end
