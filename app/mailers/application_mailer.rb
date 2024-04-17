# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  BLOGGERS_EMAIL = 'tilak@webkorps.com'

  default from: %("Bloggers" <#{BLOGGERS_EMAIL}>)
  layout 'mailer'
end
