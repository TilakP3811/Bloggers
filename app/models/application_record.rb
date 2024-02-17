# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.option_find_by(*)
    Fear.option(find_by(*))
  end

  def try_update(*)
    is_success = update(*)

    return Fear.success(nil) if is_success

    Fear.failure errors
  end
end
