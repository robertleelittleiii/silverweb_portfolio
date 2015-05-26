class AddTagsFieldToArtifacts < ActiveRecord::Migration
  def self.up
    add_column :artifacts, :tag_list, :text
  end

  def self.down
    remove_column :artifacts, :tag_list
  end
end
