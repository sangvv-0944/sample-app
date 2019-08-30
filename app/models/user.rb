class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :remember_token

  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :email, format: {with: VALID_EMAIL_REGEX},
            presence: true, length: {maximum: Settings.max_email},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_password}
  validates :password_confirmation, presence: true

  before_save{email.downcase!}

  has_secure_password

  # Crypto a string
  def self.digest string
    if ActiveModel::SecurePassword.min_cost
      BCrypt::Password.create(string, cost: BCrypt::Engine::MIN_COST)
    else
      BCrypt::Password.create(string, cost: BCrypt::Engine.cost)
    end
  end

  # Return a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # save remember_token to database
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # compare remember_token vs remember_digest
  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # forget remmeber token
  def forget
    update_attribute(:remember_digest, nil)
  end
end
