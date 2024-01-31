# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  HELLO_BLOGGER_EMAIL = 'hello@blogger.com'

  default from: %("Bloggers" <#{HELLO_BLOGGER_EMAIL}>)
  layout 'mailer'
end
