module Users
  class RegistrationsController < Devise::RegistrationsController
    def create
      form = Forms::SignUp.new sign_up_params

      form.submit
    end
  end
end
