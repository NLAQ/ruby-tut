class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_reader :remember_token
  validates :email, presence: true, length: {maximum: Settings.email.maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.password.minimum}, allow_nil: true
  validates :name, presence: true, length: {maximum: Settings.name.maximum}

  has_secure_password
  before_save :downcase

  class << self
    def digest string
      if ActiveModel::SecurePassword.min_cost
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attributes :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attributes :remember_digest, nil
  end

  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  private
  def downcase
    self.email = email.downcase
  end
end
