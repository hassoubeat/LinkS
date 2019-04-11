class News < ApplicationRecord
  scope :is_open, -> { where(is_open: 1)}
  scope :is_valid, -> { where(is_valid: 1)}
  scope :created_at_desc, -> { order(created_at: :desc)}
end
