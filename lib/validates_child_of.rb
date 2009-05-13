module ActiveRecord
  module Validations
    module ClassMethods
      # Validates the current ActiveRecord object to ensure that it is the child of another one
      #
      #   class Page < ActiveRecord::Base
      #     validates_child_of :book
      #   end
      #
      # Configuration options:
      # * <tt>message</tt> - A custom error message (default is: " must be the parent of %c")
      def validates_child_of(*attr_names)
        configuration = { :message => ' must be the parent of %c' }

        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          field_name = attr_name.to_s + "_id"
          message = configuration[:message].gsub(/%c/, record.class.to_s)
          record.errors.add(attr_name, message) unless record.attribute_present?(field_name)
        end
      end
    end   
  end
end
