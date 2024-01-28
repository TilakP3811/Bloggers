class UserMailer < ApplicationMailer
  def activate_account(registration)
    @registration = registration

    mail to: registration.user.email, subject: 'Please verify your email address'
  end

  def existing_account(user)
    mail(
      to:      user.email,
      subject: 'Your email was used to create a new account on Dr. Bill'
    )
  end
end
