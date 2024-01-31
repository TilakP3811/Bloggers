# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_account_verification

  private

  def check_account_verification
    return unless current_user
    return if current_user.verified

    redirect_to new_users_verifications_path(
      registration_uuid: current_user.incomplete_registration.uuid
    )
  end
end
