module Halogen
  module Properties # :nodoc:
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods # :nodoc:
      # @param name [Symbol, String]
      # @param options [nil, Hash]
      #
      # @return [Halogen::Properties::Definition]
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

      # @return [Hash] properties from definitions
      #
      def properties
        render_definitions(Definition.name) do |definition, result|
          result[definition.name] = definition.value(self)
        end
      end
    end
  end
end

require 'halogen/properties/definition'
