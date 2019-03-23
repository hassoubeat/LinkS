class Link < ApplicationRecord
  LINK_DEFAULT_NAME = "No Name"
  LINK_DEFAULT_SORT = 99999;
  LINK_CREATE_LIMIT = 100; # 1つのフォルダーに登録できるリンクの上限

  scope :is_valid, -> { where(is_valid: 1)}
  default_scope {order(sort: :asc, created_at: :asc)}
end
