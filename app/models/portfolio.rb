# frozen_string_literal: true

class Portfolio < ActiveRecord::Base
  has_many :artifacts
end
