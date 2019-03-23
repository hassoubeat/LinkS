class Folder < ApplicationRecord
  FOLDER_DEFAULT_NAME = "No Name"
  FOLDER_DEFAULT_SORT = 99999;
  FOLDER_CREATE_LIMIT = 100; # 1ユーザが登録できるフォルダーの上限

  scope :is_valid, -> { where(is_valid: 1)}
  default_scope {order(sort: :asc, created_at: :asc)}
end
