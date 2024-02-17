# frozen_string_literal: true

require 'rails_helper'

describe Validators::PasswordCompatible do
  subject(:user) { build_stubbed(:user, password: password, password_confirmation: password) }

  shared_examples 'has validation errors' do
    it { is_expected.not_to be_valid }

    context 'when validated' do
      before { user.validate }

      its('errors.full_messages') { is_expected.to eql expected_errors }
    end
  end

  shared_examples 'does not validate missing password' do
    context 'when password was not provided' do
      let(:password) { nil }

      it { is_expected.to be_valid }
    end
  end

  let(:expected_errors) do
    ['Password must be 8 char long and should contain at least one special character and one digit.']
  end

  it_behaves_like 'does not validate missing password'

  context 'when password is OK' do
    let(:password) { 'Pa$$word1!' }

    it { is_expected.to be_valid }
  end

  context 'when password is too simple' do
    let(:password) { 'foo-bar-buz' }

    it_behaves_like 'has validation errors'
  end

  context 'when password is too short' do
    let(:password) { 'qQ1!' }

    it_behaves_like 'has validation errors'
  end
end
