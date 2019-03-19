class Link < ApplicationRecord
  scope :is_valid, -> { where(is_valid: 1)}
  default_scope {order(sort: :asc, created_at: :asc)}
end
