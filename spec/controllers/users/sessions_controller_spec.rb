# frozen_string_literal: true

require 'rails_helper'

describe Users::SessionsController do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #new' do
    before { get :new }

    its(:response) { is_expected.to be_successful }
  end

  describe 'POST #create' do
    let(:params) { { user: { email: 'foo@emaple.com', password: 'Pa$$word1!' } } }

    def send_request
      post :create, params: params
    end

    context 'when user is not found' do
      before { send_request }

      it 'respond with unprocessable entity status' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'response with proper error message' do
        expect(controller.flash[:alert]).to eql I18n.t('devise.failure.not_found_in_database')
      end
    end

    context 'when user is available' do
      before do
        create(:user, email: 'foo@emaple.com')
        send_request
      end

      it { is_expected.to redirect_to root_path }

      it 'response with proper success message' do
        expect(controller.flash[:notice]).to eql I18n.t('devise.sessions.signed_in')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:current_user) { create(:user) }

    before do
      sign_in current_user
      delete :destroy
    end

    it { is_expected.to redirect_to root_path }
  end
end
