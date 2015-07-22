class AddSliderInfoToArtifacts < ActiveRecord::Migration
  def change
    add_column :artifacts, :slider_height, :integer
    add_column :artifacts, :slider_width, :integer
    add_column :artifacts, :slider_effect, :string
    add_column :artifacts, :slider_play_speed, :integer
    add_column :artifacts, :slider_nav, :boolean
  end
end
