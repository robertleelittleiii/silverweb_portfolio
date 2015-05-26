class AddLocationToPortfolios < ActiveRecord::Migration
  def self.up
    add_column :portfolios, :location, :string
    add_column :portfolios, :portfolio_active, :boolean
    add_column :portfolios, :position, :integer

  end

  def self.down
    remove_column :portfolios, :location
    remove_column :portfolios, :portfolio_active
    remove_column :portfolios, :position

  end
end
