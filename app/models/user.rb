class User < ApplicationRecord
  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  validates :name,
    presence: true,
    length: { maximum: 10 }

  scope :is_valid, -> { where(is_valid: 1)}
  default_scope {order(created_at: :asc)}

  # パスワードのハッシュ化
  has_secure_password
end
