# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def activate_account(registration)
    @registration = registration

    mail to: registration.user.email, subject: I18n.t('mailer.user.account_activation')
  end

  def existing_account(user)
    mail(
      to:      user.email,
      subject: I18n.t('mailer.user.account_existed')
    )
  end
end
