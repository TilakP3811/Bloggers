# frozen_string_literal: true

require 'rails_helper'

describe Registration do
  subject(:registration) { build(:registration) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    describe 'activation code' do
      context 'when empty' do
        it { is_expected.to validate_presence_of(:activation_code) }
      end

      context 'when valid' do
        it { is_expected.to be_valid }

        it 'length eql to 6' do
          expect(registration.activation_code.length).to eq(6)
        end
      end
    end
  end
end
