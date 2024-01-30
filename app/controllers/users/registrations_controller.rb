module Users
  class RegistrationsController < Devise::RegistrationsController
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
      redirect_to new_users_verifications_path(registration_uuid: results.registrations.uuid)
    end

    def handle_failure(err)
      flash[:error] = "Invalid input: #{err.full_messages.join '; '}"
      redirect_to new_user_registration_path
    end
  end
end
