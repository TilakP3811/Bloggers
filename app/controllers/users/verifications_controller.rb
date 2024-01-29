module Users
  class VerificationsController < ApplicationController
    skip_before_action :check_account_verification

    def new
    end

    def create
      form = Forms::SignupVerification.new(verification_params: verification_params)

      form.submit.match do |m|
        m.success {}
        m.failure { |err| flash[:error] = "Verification failed: #{err.full_messages.join '; '}" }
      end

      redirect_to root_path
    end

    private

    def verification_params
      params.require(:verification).permit(:registration_uuid, :activation_code)
    end
  end
end
