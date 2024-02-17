# frozen_string_literal: true

require 'rails_helper'

describe ApplicationRecord do
  let(:record_class) do
    Class.new(described_class) do
      validate :already_persisted

      self.table_name = 'users'

      private

      def already_persisted
        return if id

        errors.add :id, 'not there'
      end
    end
  end
  let(:record) { record_class.new }

  describe '#option_find_by' do
    subject { find }

    before { allow(described_class).to receive(:find_by).and_return result }

    def find
      described_class.option_find_by foo: 123
    end

    context 'when returns nil' do
      let(:result) { nil }

      it { is_expected.to be_none }
    end

    context 'when returns something' do
      let(:result) { instance_double described_class }

      it { is_expected.to be_some }

      it 'passes correct args' do
        find # trigger method call
        expect(described_class).to have_received(:find_by).with foo: 123
      end
    end
  end

  describe '#try_update' do
    subject(:result) { update }

    def update
      record.try_update id: id
    end

    context 'when success' do
      let(:id) { 123 }

      it { is_expected.to be_success }

      it 'wraps nothing' do
        expect(result.get).to be_nil
      end
    end

    context 'when fails' do
      let(:id) { nil }

      it { is_expected.to be_failure }

      it 'wraps validations errors' do
        expect(result.exception.as_json).to eql id: ['not there']
      end
    end
  end
end
