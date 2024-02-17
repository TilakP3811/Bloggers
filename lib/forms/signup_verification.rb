# frozen_string_literal: true

# TODO: verify user is present of not verified before proceed
module Forms
  class SignupVerification < BaseForm
    attr_accessor :verification_params

    INVALID_ACTIVATION_CODE = 'is invalid.'

    def initialize(verification_params:)
      @verification_params = verification_params

      super
    end

    private

    def do_submit
      maybe_incomplete_registration.match do |m|
        m.some { |registration| complete_registration(registration) }
        m.none { add_field_error :activation_code, INVALID_ACTIVATION_CODE }
      end
    end

    def maybe_incomplete_registration
      Registration.option_find_by(
        uuid:            verification_params[:registration_uuid],
        activation_code: verification_params[:activation_code]
      )
    end

    def complete_registration(registration)
      registration.user.try_update(verified: true).map_err { report_unknown_error }
    end
  end
end
