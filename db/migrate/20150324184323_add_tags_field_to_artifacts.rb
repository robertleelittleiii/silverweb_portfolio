# frozen_string_literal: true

class AddTagsFieldToArtifacts < ActiveRecord::Migration[5.0]
  def self.up
    add_column :artifacts, :tag_list, :text
  end

  def self.down
    remove_column :artifacts, :tag_list
  end
end
