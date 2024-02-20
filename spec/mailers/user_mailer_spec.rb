# frozen_string_literal: true

require 'rails_helper'

describe UserMailer do
  describe '#activate_account' do
    let(:user) { create(:user) }
    let(:registration) { build(:registration, activation_code: 'ZZZXXX', user: user) }
    let(:mail) { described_class.activate_account(registration).deliver_now }

    it 'sets the destination' do
      expect(mail.to).to eq [user.email]
    end

    it 'sets the subject' do
      expect(mail.subject).to eq I18n.t('mailer.user.account_activation')
    end

    it 'has an activation code' do
      expect(mail.body.encoded).to match 'ZZZXXX'
    end
  end

  describe '#existing_account' do
    let(:user) { create(:user) }
    let(:mail) { described_class.existing_account(user).deliver_now }

    it 'sets the destination' do
      expect(mail.to).to eq [user.email]
    end

    it 'sets the subject' do
      expect(mail.subject).to eq I18n.t('mailer.user.account_existed')
    end

    it 'has an activation code' do
      expect(mail.body.encoded).to match 'Account existed'
    end
  end
end
