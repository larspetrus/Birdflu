# frozen_string_literal: true

class Star < ActiveRecord::Base
  belongs_to :galaxy
  belongs_to :raw_alg
end
