# frozen_string_literal: true

require 'rails_helper'

describe Forms::SignUp do
  subject(:submit) { form.submit }

  let(:form) { described_class.new(params) }
  let(:params) { { email: 'foo@example.com', password: 'P@ssword1', password_confirmation: 'P@ssword1' } }

  def queued_job
    perform_enqueued_jobs do
      submit
    end
  end

  describe 'validations' do
    context 'when email not exist' do
      let(:params) { { email: '', password: 'P@ssword1', password_confirmation: 'P@ssword1' } }

      it { is_expected.to be_failure }
      its('exception.as_json') { is_expected.to eql email: [I18n.t('devise.failure.invalid_email')] }
    end

    context 'when email has wrong format' do
      let(:params) { { email: 'foo@example', password: 'P@ssword1', password_confirmation: 'P@ssword1' } }

      it { is_expected.to be_failure }
      its('exception.as_json') { is_expected.to eql email: [I18n.t('devise.failure.invalid_email')] }
    end

    context 'when password is empty' do
      let(:params) { { email: 'foo@example.com', password: '', password_confirmation: '' } }

      it { is_expected.to be_failure }
      its('exception.as_json') { is_expected.to eql password: [I18n.t('devise.failure.invalid_password')] }
    end

    context 'when password has wrong format' do
      let(:params) { { email: 'foo@example.com', password: '123', password_confirmation: '123' } }

      it { is_expected.to be_failure }
      its('exception.as_json') { is_expected.to eql password: [I18n.t('devise.failure.invalid_password')] }
    end

    context 'when password not match with password confirmation' do
      let(:params) { { email: 'foo@example.com', password: 'P@ssword1', password_confirmation: '123' } }

      it { is_expected.to be_failure }

      its('exception.as_json') do
        is_expected.to eql password_confirmation: [I18n.t('devise.failure.invalid_password_confirmation')]
      end
    end
  end

  context 'when account already exist with the email' do
    before { create(:user, email: 'foo@example.com') }

    it { is_expected.to be_failure }
    its('exception.as_json') { is_expected.to eql email: [I18n.t('devise.failure.email_existed')] }

    it 'sends mail for the information' do
      expect { queued_job }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'mail contains account existed information' do
      queued_job
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to include I18n.t('mailer.user.account_existed')
    end
  end

  context 'when account is new with the email' do
    it { is_expected.to be_success }

    it 'creates registration token for the user' do
      expect { submit }.to change(Registration, :count).by(1)
    end

    it 'mail contains account verification instructions' do
      queued_job
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to include I18n.t('mailer.user.account_activation')
    end

    it 'creates user account successfully' do
      expect { submit }.to change(User, :count).by(1)
    end
  end
end
