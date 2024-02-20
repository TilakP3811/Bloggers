# frozen_string_literal: true

require 'rails_helper'

describe Forms::SignupVerification do
  subject(:submit) { form.submit }

  let(:registration) { create(:registration, user: current_user) }
  let(:current_user) { create(:user, :incomplete_verification) }
  let(:params) { { registration_uuid: registration.uuid, activation_code: registration.activation_code } }
  let(:form) { described_class.new(verification_params: params) }

  context 'when user is already verified' do
    let(:current_user) { create(:user) }

    it { is_expected.to be_failure }

    its('exception.as_json') do
      is_expected.to eql activation_code: [I18n.t('devise.confirmations.already_confirmed')]
    end
  end

  context 'when registration is valid' do
    it { is_expected.to be_success }
    it { is_expected.to eq Fear.success Fear.none }

    it 'mark user as verified' do
      expect { submit }.to change { registration.user.reload.verified }.from(false).to(true)
    end
  end

  context 'when registration is invalid' do
    let(:params) { { registration_uuid: '123', activation_code: registration.activation_code } }

    it { is_expected.to be_failure }

    its('exception.as_json') do
      is_expected.to eql activation_code: [Forms::SignupVerification::INVALID_ACTIVATION_CODE]
    end

    it 'not mark user as verified' do
      expect { submit }.not_to change(registration.user.reload, :verified)
    end
  end
end
