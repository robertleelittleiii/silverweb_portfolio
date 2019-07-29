# frozen_string_literal: true

class RenameMetarobotsInPortfolios < ActiveRecord::Migration[5.0]
  def self.up
    rename_column :portfolios, :meta_robots, :meta_robot
  end

  def self.down
    rename_column :portfolios, :meta_robot, :meta_robots
  end
end
