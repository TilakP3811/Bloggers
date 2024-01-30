require 'active_model'

module Validators
  class PasswordCompatible < ActiveModel::Validator
    def validate(user)
      return if !password_required?(user)

      return if user.password.match?(User::PASSWORD_FORMAT)

      user.errors.add :password, I18n.t('devise.failure.invalid_password')
    end

    private

    def password_required?(user)
      !user.persisted? || !user.password.nil? || !user.password_confirmation.nil?
    end
  end
end
