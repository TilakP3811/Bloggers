# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :check_account_verification
  end
end
