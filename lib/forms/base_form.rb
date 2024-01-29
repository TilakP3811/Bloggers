# frozen_string_literal: true

require 'fear'

module Forms
  class BaseForm
    include ActiveModel::Model

    def submit
      validate

      do_submit if valid?

      errors.empty? ? Fear.success(ok_result) : err_result
    end

    private

    def do_submit; end

    # :reek:UtilityFunction
    def ok_result
      Fear.none
    end

    def save_or_report_error(model)
      return Fear.some model if model.save

      Fear.none
    end

    def err_result
      Fear.failure errors
    end

    def add_field_error(field_name, error)
      errors.add field_name, error
    end

    def add_non_field_error(error)
      return if errors[:non_field_errors].include? error

      errors.add :non_field_errors, error
    end

    def report_unknown_error(field_name)
      add_non_field_error 'Something went wrong!'
    end
  end
end
