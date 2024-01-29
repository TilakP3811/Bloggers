module Forms
  class SignUp < BaseForm
    class SignUpResult
      attr_reader :user, :registrations

      def initialize(registrations:)
        @user             = registrations.user
        @registrations    = registrations
      end
    end

    attr_accessor :email, :password, :password_confirmation, :registrations_uuid

    def initialize(*args)
      super

      @registrations_uuid = SecureRandom.uuid
    end

    private

    def do_submit
      maybe_existing_user.match do |m|
        m.some { |user| existing_account(user) }
        m.none { new_account }
      end
    end

    def ok_result
      SignUpResult.new(registrations: @user_registration)
    end

    def maybe_existing_user
      User.option_find_by(email: @email)
    end

    def new_account
      create_user.each do |user|
        create_registration_for(user)
      end
    end

    def create_user
      user = User.new(
        email:      @email,
        password:   @password
      )

      save_or_report_error user
    end

    def create_registration_for(user)
      maybe_create_registration_for(user).each do |registration|
        send_mail_to_activate_account_for registration
      end
    end

    def maybe_create_registration_for(user)
      activation_code = SecureRandom.alphanumeric(6).upcase

      save_or_report_error(user_registration(user, activation_code))
    end

    def user_registration(user, activation_code)
      @user_registration ||= Registration.new(user: user, uuid: registrations_uuid, activation_code: activation_code)
    end

    def existing_account(user)
      UserMailer.existing_account(user).deliver_later
    end

    def send_mail_to_activate_account_for(registration)
      UserMailer.activate_account(registration).deliver_later
    end
  end
end
