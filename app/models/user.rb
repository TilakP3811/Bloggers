class User < ApplicationRecord
  EMAIL_FORMAT = /([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)/
  PASSWORD_FORMAT = /(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable, :lockable

  has_one :incomplete_registration, class_name: 'Registration', dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: true },
            format: { with: EMAIL_FORMAT, message: I18n.t('devise.failure.invalid_email') }
  validates :password, confirmation: true

  validates_with Validators::PasswordCompatible
end
