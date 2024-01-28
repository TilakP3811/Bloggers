class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.option_find_by(*args)
    Fear.option(find_by(*args))
  end
end
