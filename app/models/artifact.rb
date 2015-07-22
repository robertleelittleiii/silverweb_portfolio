class Artifact < ActiveRecord::Base
  
  belongs_to :portfolio
  
  has_many :pictures,  -> { order(position: :asc) },  dependent: :destroy, as: :resource
  
  acts_as_taggable_on :category, :department

  def action_viewer
    
    return (artifact_action_viewer.blank? ? "artifact_detail" : artifact_action_viewer) rescue "artifact_detail"
    
  end
  
  def next_in_portfolio 
    artifact_list = self.portfolio.artifacts.where(:artifact_active=>1).order(:position)
     if artifact_list.length <= 1 then
      return self
    end
    artifact_list.index(self)
    if artifact_list.last == self then
      return artifact_list.first
    else
      return artifact_list[artifact_list.index(self) + 1 ]
    end
  end
  
  def previous_in_portfolio
    artifact_list =  self.portfolio.artifacts.where(:artifact_active=>1).order(:position)
    
    if artifact_list.empty? or artifact_list.length <= 1 then
      return self
    end
    
    
    artifact_list.index(self)
    
    if artifact_list.first == self then
      return artifact_list.last
    else
      return artifact_list[artifact_list.index(self) - 1 ] rescue self
    end
  end
  
end
