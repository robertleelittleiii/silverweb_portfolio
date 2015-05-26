class Artifact < ActiveRecord::Base
  
  belongs_to :portfolio
  
  has_many :pictures,  -> { order(position: :asc) },  dependent: :destroy, as: :resource
  
  acts_as_taggable_on :category, :department

  
end
