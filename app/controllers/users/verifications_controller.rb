# frozen_string_literal: true

module Users
  class VerificationsController < ApplicationController
    skip_before_action :check_account_verification

    def new
      return unless current_user.verified

      flash[:error] = I18n.t('devise.confirmations.already_confirmed')
      redirect_to root_path
    end

    def create
      Forms::SignupVerification.new(verification_params:).submit.match do |m|
        m.success { send_verification_success }
        m.failure { |err| send_verification_failed(err) }
      end
    end

    private

    def send_verification_success
      flash[:notice] = I18n.t('devise.confirmations.confirmed')
      redirect_to root_path
    end

    def send_verification_failed(err)
      flash[:error] = "Verification failed: #{err.full_messages.join ', '}"
      redirect_to action: :new, registration_uuid: current_user.incomplete_registration.uuid
    end

    def verification_params
      params.require(:verification).permit(:registration_uuid, :activation_code)
    end
  end
end
