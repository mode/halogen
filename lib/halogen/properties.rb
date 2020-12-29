module Halogen2
  module Properties # :nodoc:
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods # :nodoc:
      # @param name [Symbol, String]
      # @param options [nil, Hash]
      #
      # @return [Halogen2::Properties::Definition]
      #
      def property(name, options = {}, &procedure)
        define_singleton_method("get_property_#{name}") do |resource|
          if procedure
            procedure.call(resource)
          else
            # if respond_to?(name.to_sym)
            #   send(name.to_sym, resource)
            # else
              resource.send(name.to_sym)
            # end
          end
        end

        definitions.add(Definition.new(name, options, procedure))
      end
    end
  end
end

require 'halogen2/properties/definition'
