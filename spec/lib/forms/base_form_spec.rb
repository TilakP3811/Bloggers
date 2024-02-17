# frozen_string_literal: true

require_relative '../../../lib/forms'
require 'active_model'
require 'rails_helper'

describe Forms::BaseForm do
  subject { form.submit }

  let(:form) { model_class.new attrs }
  let(:attrs) { { foo: 123 } }
  let(:model_class) do
    Class.new(described_class) do
      validates_presence_of :foo

      attr_accessor :foo, :foo1
    end
  end

  before do
    allow(form).to receive :do_submit
    stub_const 'TestForm', model_class
  end

  context 'when valid' do
    it { is_expected.to be_success }
    its(:get) { is_expected.to be_empty }

    it 'does submit' do
      form.submit

      expect(form).to have_received :do_submit
    end
  end

  context 'when invalid' do
    let(:attrs) { {} }

    it { is_expected.to be_failure }
    its('exception.as_json') { is_expected.to eql foo: ["can't be blank"] }

    it 'does not submit' do
      form.submit

      expect(form).not_to have_received :do_submit
    end
  end

  describe '#add_non_field_error' do
    def add_non_field_error(error)
      form.send :add_non_field_error, error
    end

    context 'when call' do
      before { add_non_field_error 'An error' }

      it 'adds an error' do
        expect(form.errors.messages[:non_field_errors]).to eql ['An error']
      end
    end

    context 'when call more than one time' do
      before do
        add_non_field_error 'First error'
        add_non_field_error 'Second error'
      end

      it 'adds a new error' do
        expect(form.errors.messages[:non_field_errors]).to eql ['First error', 'Second error']
      end
    end

    context 'when call more than one time with the same error message' do
      before do
        add_non_field_error 'Same error'
        add_non_field_error 'Same error'
      end

      it 'does not duplicate new error message' do
        expect(form.errors.messages[:non_field_errors]).to eql ['Same error']
      end
    end
  end

  describe '#add_field_error' do
    def add_field_error(field_error, error)
      form.send :add_field_error, field_error, error
    end

    context 'when call' do
      before { add_field_error :foo, 'An error' }

      it 'adds an error' do
        expect(form.errors.messages[:foo]).to eql ['An error']
      end
    end

    context 'when call more than one time' do
      before do
        add_field_error :foo, 'First error'
        add_field_error :foo, 'Second error'
      end

      it 'adds a new error' do
        expect(form.errors.messages[:foo]).to eql ['First error', 'Second error']
      end
    end

    context 'when add more than one field errors' do
      before do
        add_field_error :foo, 'First error'
        add_field_error :foo1, 'Second error'
      end

      it 'adds a new foo error' do
        expect(form.errors.messages[:foo]).to eql ['First error']
      end

      it 'adds another new foo1 error' do
        expect(form.errors.messages[:foo1]).to eql ['Second error']
      end
    end
  end
end
