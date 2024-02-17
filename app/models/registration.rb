# frozen_string_literal: true

class Registration < ApplicationRecord
  self.primary_key = 'uuid'

  belongs_to :user

  validates :activation_code, presence: true
end
