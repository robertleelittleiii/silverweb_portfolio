# frozen_string_literal: true

class Artifact < ActiveRecord::Base
  belongs_to :portfolio, optional: true


  has_many :pictures, -> { order(position: :asc) }, dependent: :destroy, as: :resource

  acts_as_taggable_on :category, :department

  def action_viewer
    (artifact_action_viewer.blank? ? 'artifact_detail' : artifact_action_viewer)
  rescue StandardError
    'artifact_detail'
  end

  def next_in_portfolio
    artifact_list = portfolio.artifacts.where(artifact_active: 1).order(:position)
    return self if artifact_list.length <= 1

    artifact_list.index(self)
    if artifact_list.last == self
      return artifact_list.first
    else
      begin
      return artifact_list[artifact_list.index(self) + 1]
      rescue StandardError
        self
    end
    end
  rescue StandardError
    self
  end

  def previous_in_portfolio
    artifact_list = portfolio.artifacts.where(artifact_active: 1).order(:position)

    return self if artifact_list.empty? || (artifact_list.length <= 1)

    artifact_list.index(self)

    if artifact_list.first == self
      return artifact_list.last
    else
      begin
      return artifact_list[artifact_list.index(self) - 1]
      rescue StandardError
        self
    end
    end
  rescue StandardError
    self
  end
end
