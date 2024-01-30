module Users
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :check_account_verification

    def create
      form = Forms::SignUp.new sign_up_params

      form.submit.match do |m|
        m.success { |results| handle_success(results) }
        m.failure { |err| handle_failure(err) }
      end
    end

    private

    def handle_success(results)
      sign_in results.user
      flash[:notice] = I18n.t('devise.confirmations.send_instructions')
      redirect_to new_users_verifications_path(registration_uuid: results.registrations.uuid)
    end

    def handle_failure(err)
      sign_out
      self.resource = resource_class.new(sign_up_params)
      resource.save
      respond_with resource, location: new_user_registration_path(resource)
    end
  end
end
