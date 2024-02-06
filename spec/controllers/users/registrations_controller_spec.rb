# frozen_string_literal: true

require 'rails_helper'

describe Users::RegistrationsController do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #new' do
    subject { response }

    context 'when user is not singed in' do
      before { get :new }

      it { is_expected.to be_successful }
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
    subject { response }

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

        it { is_expected.to be_successful }
      end
    end
  end
end
