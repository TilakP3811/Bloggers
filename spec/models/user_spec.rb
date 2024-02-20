# frozen_string_literal: true

require 'rails_helper'

describe User do
  subject(:user) { build(:user) }

  describe 'associations' do
    it { is_expected.to have_one(:incomplete_registration).class_name('Registration') }
  end

  describe 'validations' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'is valid with a email, password and password confirmation' do
      user = described_class.new(email:                 'test@example.com',
                                 password:              'Pa$$word1!',
                                 password_confirmation: 'Pa$$word1!')
      expect(user).to be_valid
    end

    describe 'email' do
      context 'when empty' do
        before { user.email = '' }

        it { is_expected.to validate_presence_of(:email) }
      end

      context 'when wrong format' do
        before { user.email = 'foo@example' }

        it { is_expected.not_to be_valid }
      end

      context 'when correct format' do
        before { user.email = 'foo@emaple.com' }

        it { is_expected.to be_valid }
      end
    end

    describe 'password' do
      context 'when empty' do
        before { user.password = '' }

        it { is_expected.not_to be_valid }
      end

      context 'when length is not 8' do
        before do
          user.password = 'p@sw0rd'
          user.password_confirmation = 'p@sw0rd'
        end

        it { is_expected.not_to be_valid }
      end

      context 'when not contain any special char or digit' do
        before do
          user.password = 'password'
          user.password_confirmation = 'password'
        end

        it { is_expected.not_to be_valid }
      end

      context 'when password confirmation is not matches' do
        before do
          user.password = 'P@ssword1'
          user.password_confirmation = 'password'
        end

        it { is_expected.not_to be_valid }
      end

      context 'when has strong password' do
        before do
          user.password = 'P@ssword1'
          user.password_confirmation = 'P@ssword1'
        end

        it { is_expected.to be_valid }
      end
    end
  end
end
