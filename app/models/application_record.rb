class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.option_find_by(*args)
    Fear.option(find_by(*args))
  end

  def self.wrap_optionals
    columns.each do |column|
      next if !column.null

      define_method column.name do
        Fear.option self[column.name]
      end
    end
  end

  def try_update(*args)
    is_success = update(*args)

    return Fear.success(nil) if is_success

    Fear.failure errors
  end
end
