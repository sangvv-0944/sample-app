class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :email, format: {with: VALID_EMAIL_REGEX},
            presence: true, length: {maximum: Settings.max_email},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_password}
  validates :password_confirmation, presence: true

  before_save{email.downcase!}

  has_secure_password

  def self.digest string
    if ActiveModel::SecurePassword.min_cost
      BCrypt::Password.create(string, cost: BCrypt::Engine::MIN_COST)
    else
      BCrypt::Password.create(string, cost: BCrypt::Engine.cost)
    end
  end
end
