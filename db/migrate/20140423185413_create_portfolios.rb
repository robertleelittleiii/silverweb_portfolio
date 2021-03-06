class CreatePortfolios < ActiveRecord::Migration
  def self.up
    create_table :portfolios do |t|
      t.string :name
      t.text :description
      t.text :meta_description
      t.text :meta_keywords
      t.string :meta_robots

      t.timestamps
    end
  end

  def self.down
    drop_table :portfolios
  end
end
