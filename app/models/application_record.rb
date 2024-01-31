# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.option_find_by(*)
    Fear.option(find_by(*))
  end

  def self.wrap_optionals
    columns.each do |column|
      next unless column.null

      define_method column.name do
        Fear.option self[column.name]
      end
    end
  end

  def try_update(*)
    is_success = update(*)

    return Fear.success(nil) if is_success

    Fear.failure errors
  end
end
