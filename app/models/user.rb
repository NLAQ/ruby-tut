class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: {maximum: Settings.email.maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.password.minimum}
  validates :name, presence: true, length: {maximum: Settings.name.maximum}

  has_secure_password
  before_save :downcase

  private

  def downcase
    self.email = email.downcase
  end
end
