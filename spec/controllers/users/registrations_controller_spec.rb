# frozen_string_literal: true

require 'rails_helper'

describe Users::RegistrationsController do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #new' do
    context 'when user is not singed in' do
      before { get :new }

      its(:response) { is_expected.to be_successful }
    end

    context 'when user is signed in' do
      let(:current_user) { create(:user) }

      before do
        sign_in current_user
        get :new
      end

      it { is_expected.to redirect_to root_path }
    end
  end

  describe 'GET #edit' do
    context 'when user is not signed in' do
      before { get :edit }

      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user is signed in' do
      before do
        sign_in current_user
        get :edit
      end

      context 'when account is not verified' do
        let(:current_user) { create(:user, :incomplete_verification, incomplete_registration: registration) }
        let(:registration) { create(:registration) }

        it { is_expected.to redirect_to new_users_verifications_path(registration_uuid: registration.uuid) }
      end

      context 'when account is verified' do
        let(:current_user) { create(:user) }

        its(:response) { is_expected.to be_successful }
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user, :incomplete_verification) }
    let(:registration) { create(:registration, user: user) }
    let(:form_result) { Fear.success Forms::SignUp::SignUpResult.new registrations: registration }
    let(:params) do
      {
        user: {
          email:                 'foo@gmail.com',
          password:              'P@ssword1',
          password_confirmation: 'P@ssword1',
        },
      }
    end

    before do
      form = instance_double Forms::SignUp
      allow(Forms::SignUp).to receive(:new).and_return form
      allow(form).to receive(:submit).and_return form_result
    end

    def send_request
      post :create, params: params
    end

    context 'when success' do
      before { send_request }

      it 'signs in user' do
        expect(controller.current_user).to eql user
      end

      it { is_expected.to redirect_to new_users_verifications_path(registration_uuid: registration.uuid) }

      it 'shows success message' do
        expect(controller.flash[:notice]).to eql I18n.t('devise.confirmations.send_instructions')
      end
    end

    context 'when failure' do
      let(:error_message) { { non_field_errors: ['An error'] } }
      let(:form_result) { Fear.failure error_message }

      before { send_request }

      its(:response) { is_expected.not_to be_successful }

      it 'does not sign in user' do
        expect(controller.current_user).to be_nil
      end
    end
  end
end
