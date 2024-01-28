# frozen_string_literal: true

require 'fear'

module Fear
  class Some
    def some?
      true
    end

    def none?
      false
    end

    def and_then
      yield @value
    end
  end
end

module Fear
  class Failure
    def map_err
      yield @exception
    end
  end
end

module Fear
  class Success
    def map_err
      self
    end
  end
end

Fear.const_get(:NoneClass).class_eval do
  def some?
    false
  end

  def none?
    true
  end

  def and_then
    self
  end
end
