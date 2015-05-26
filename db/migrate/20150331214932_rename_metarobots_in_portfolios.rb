class RenameMetarobotsInPortfolios < ActiveRecord::Migration
  def self.up
    rename_column :portfolios, :meta_robots, :meta_robot

  end

  def self.down
    rename_column :portfolios, :meta_robot, :meta_robots

  end
end
