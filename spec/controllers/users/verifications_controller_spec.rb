# frozen_string_literal: true

require 'rails_helper'

describe Users::VerificationsController do
  describe 'GET #new' do
    before do
      sign_in current_user
      get :new
    end

    context 'when user is not verified' do
      let(:current_user) { create(:user) }

      it { is_expected.to redirect_to root_path }

      it 'response with proper error message' do
        expect(controller.flash[:error]).to eql I18n.t('devise.confirmations.already_confirmed')
      end
    end

    context 'when user is verified' do
      let(:current_user) { create(:user, :incomplete_verification) }

      its(:response) { is_expected.to be_successful }
    end
  end

  describe 'POST #create' do
    let(:current_user) { create(:user, :incomplete_verification) }
    let(:registration) { create(:registration, user: current_user) }
    let(:verification_params) do
      { registration_uuid: registration.uuid, activation_code: registration.activation_code }
    end
    let(:form_result) { Fear.success Fear.none }

    def send_request
      post :create, params: { verification: verification_params }
    end

    before do
      form = Forms::SignupVerification.new(verification_params: verification_params)
      allow(Forms::SignupVerification).to receive(:new).and_return(form)
      allow(form).to receive(:submit).and_return(form_result)
      sign_in current_user
      send_request
    end

    context 'when verification token is correct' do
      it { is_expected.to redirect_to root_path }

      it 'response with proper success message' do
        expect(controller.flash[:notice]).to eql I18n.t('devise.confirmations.confirmed')
      end
    end

    context 'when verification token is incorrect' do
      let(:error) { instance_double ActiveModel::Errors, full_messages: ['Activation code is invalid.'] }
      let(:form_result) { Fear.failure error }

      it { is_expected.to redirect_to new_users_verifications_path(registration_uuid: registration.uuid) }

      it 'response with proper error message' do
        expect(controller.flash[:error]).to eql 'Verification failed: Activation code is invalid.'
      end
    end
  end
end
