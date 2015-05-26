class CreateArtifacts < ActiveRecord::Migration
  def self.up
    create_table :artifacts do |t|
      t.string :name
      t.text :description
      t.integer :portfolio_id

      t.timestamps
    end
  end

  def self.down
    drop_table :artifacts
  end
end
