class News < ApplicationRecord
  scope :is_valid, -> { where(is_valid: 1)}
end
