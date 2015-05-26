Picture.class_eval do
  #class Picture < ActiveRecord::Base
  #end
  belongs_to :artifacts, :polymorphic => true
end